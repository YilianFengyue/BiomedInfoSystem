package org.csu.controller;


import org.csu.domain.UserProfiles;
import org.csu.domain.Users;
import org.csu.dto.SetPasswordDto;
import org.csu.dto.UpdatePasswordDto;
import org.csu.dto.UserInofDto;
import org.csu.dto.UserResourceDto;
import org.csu.service.IUserProfilesService;
import org.csu.service.IUsersService;
import org.csu.util.AuthenticationHelperUtil;
import org.csu.util.PasswordUtil;
import org.csu.util.ThreadLocalUtil;
import org.hibernate.validator.constraints.URL;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;


import static org.csu.controller.Code.*;

@RestController
@RequestMapping("/users")
@Validated
public class UserContorller {

    @Autowired
    private IUsersService userService;

    @Autowired
    private IUserProfilesService userProfilesService;

    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    @Autowired
    private AuthenticationHelperUtil authHelperUtil;

    @PostMapping("/register")
    public Result register(@RequestBody Users user) {
        // 1. 从传入的 user 对象中获取用户名和密码
        String username = user.getUsername();
        String password = user.getPasswordHash();

        // 校验一下传入的参数是否为空，增加代码健壮性
        if (username == null || username.trim().isEmpty() || password == null || password.isEmpty()) {
            return new Result(1, null, "用户名或密码不能为空");
        }

        // 2. 使用一个新的变量来接收数据库的查询结果
        // 注意：这里假设您的IUsersService中有findByUserName方法，
        // 并且MyBatis-Plus的Service实现中已经注入了对应的Mapper。
        Users dbUser = userService.findByUserName(username);

        // 3. 判断查询结果 (dbUser)
        if (dbUser == null) {
            // 用户名未被占用，可以执行注册逻辑
            // 重要：传递给注册方法的是前端传来的原始用户名和密码
            userService.register(username, password);
            // 假设您的Result构造函数是 Result(code, data, message)
            return  new Result(SAVE_OK, null, "注册成功");
        } else {
            // 用户名已被占用
            return  new Result(SAVE_ERR, null, "用户名被占用");
        }
    }


        @PostMapping("/login")
        public Result login(@RequestBody Users user) {
            Users loginUser = userService.findByUserName(user.getUsername());

            if (loginUser == null) {
                return new Result(LOGIN_ERR,null,"用户名错误");
            }

            if (!PasswordUtil.checkPassword(user.getPasswordHash(), loginUser.getPasswordHash())) {
                return new Result(LOGIN_ERR,null,"密码错误");
            } else {
                Map<String, String> responseData = authHelperUtil.handleLoginSuccess(loginUser);
                return new Result(LOGIN_OK,responseData,"登录成功");
            }
        }


    @GetMapping("/userInfo")
    public Result userinfo() {
        // 从线程上下文中获取当前用户ID
        Map<String, Object> threadLocal = ThreadLocalUtil.getThreadLocal();
        int id = (int) threadLocal.get("id");

        // 1. 查询用户基本信息（假设通过用户ID能获取到User对象）
        Users user = userService.getById(id);
        if (user == null) {
            return new Result(GET_ERR, null, "用户不存在");
        }

        // 2. 查询用户资料信息
        UserProfiles userProfiles = userProfilesService.getById(id);
        if (userProfiles == null) {
            // 根据业务需求决定是否返回错误或只返回用户基本信息
            return new Result(GET_ERR, null, "用户资料不存在");
        }

        // 3. 构建并填充DTO
        UserInofDto dto = new UserInofDto();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setRole(user.getRole());
        dto.setCreatedAt(user.getCreatedAt());
        dto.setNickname(userProfiles.getNickname());
        dto.setAvatarUrl(userProfiles.getAvatarUrl());
        dto.setBio(userProfiles.getBio());

        return new Result(GET_OK, dto, "获取成功");
    }

    @PutMapping("/update")
    public Result updateUserInfo(@RequestBody @Validated UserProfiles userProfiles) {
        // 1. 从 ThreadLocal 获取当前登录用户的ID，这是安全可信的
        Map<String, Object> threadLocalData = ThreadLocalUtil.getThreadLocal();
        Integer currentUserId = (Integer) threadLocalData.get("id"); // 假设ID是Integer类型

        // 2. 忽略前端传来的任何userId，强制使用当前登录用户的ID
        //    这确保了用户永远只能修改自己的个人资料
        userProfiles.setUserId(currentUserId.longValue());

        // 3. 执行更新操作
        // 注意：这里的 service 方法名最好是 updateById，更清晰
        userProfilesService.updateById(userProfiles);

        return new Result(UPDATE_OK,userProfiles,"更新成功");
    }

    @PatchMapping("/updateAvatar")
    public Result updateAvatar(@RequestParam("avatar") @URL String avatar) {
        // 1. 从 ThreadLocal 获取当前登录用户的ID，这是安全且必须的
        Map<String, Object> claims = ThreadLocalUtil.getThreadLocal();
        Integer userId = (Integer) claims.get("id");

        // 2. 创建一个只包含主键和待更新字段的对象
        //    MyBatis-Plus 的 updateById 会进行智能部分更新
        UserProfiles profileToUpdate = new UserProfiles();

        //    设置主键，告诉MyBatis-Plus要更新哪一条记录
        profileToUpdate.setUserId(userId.longValue());

        //    设置要更新的字段和新值
        profileToUpdate.setAvatarUrl(avatar); // 假设您的实体字段名为 avatarUrl

        // 3. 调用 Service 的 updateById 方法执行更新
        userProfilesService.updateById(profileToUpdate);

        return new Result(UPDATE_OK, null, "更新头像成功"); // 您的Result构造方式
    }

    @PostMapping("set-password")
    public Result setPassword(@RequestBody @Validated SetPasswordDto passwordDto) {
        // 确认两次密码输入一致
        if (!passwordDto.getNew_pwd().equals(passwordDto.getRe_pwd())) {
            return Result.error("两次输入的新密码不一致");
        }

        // 从 ThreadLocal 获取当前用户ID
        Map<String, Object> claims = ThreadLocalUtil.getThreadLocal();
        Long userId = ((Integer) claims.get("id")).longValue();

        // 确认该用户没有密码
        Users user = userService.getById(userId);
        if (!"OAUTH2_USER".equals(user.getPasswordHash())) {
            return Result.error("操作失败：您的账户已设置密码，请使用“修改密码”功能。");
        }

        // 更新密码
        String newHashedPassword = PasswordUtil.hashPassword(passwordDto.getNew_pwd());
        userService.updatePwd(userId, newHashedPassword);

        return Result.success("登录密码设置成功！");
    }

    @PatchMapping("/updatePwd")
    public Result updatePwd(@RequestBody @Validated UpdatePasswordDto passwordDto, @RequestHeader("Authorization") String token) {
        // 1. 确认新密码是否一致
        if (!passwordDto.getRe_pwd().equals(passwordDto.getNew_pwd())) {
            return new Result(UPDATE_ERR, null, "两次输入的新密码不一致");
        }

        // 2. 从 ThreadLocal 获取用户信息
        Map<String, Object> claims = ThreadLocalUtil.getThreadLocal();
        String username = (String) claims.get("username");
        Long userId = ((Integer) claims.get("id")).longValue();

        String storedPasswordHash = userService.getById(userId).getPasswordHash();
        if ("OAUTH2_USER".equals(storedPasswordHash)) {
            return Result.error("操作失败：您的账户尚未设置密码，请使用“设置密码”功能。");
        }

        // 3. 校验原密码
        if (!PasswordUtil.checkPassword(passwordDto.getOld_pwd(), storedPasswordHash)) {
            return new Result(UPDATE_ERR, null, "原密码填写错误");
        }

        // 4. 更新密码（调用设计更佳的Service方法）
        String newHashedPassword = PasswordUtil.hashPassword(passwordDto.getNew_pwd());
        userService.updatePwd(userId, newHashedPassword); // 显式传递userId

        // 5. 让当前Token失效
        if (token != null) {
            stringRedisTemplate.delete(token);
        }

        return new Result(UPDATE_OK, null, "密码修改成功，请重新登录");
    }

    /**
     * 新增接口：获取所有教师列表
     * @return 包含所有教师详细信息的列表
     */
    @GetMapping("/teachers")
    public Result<List<UserInofDto>> getAllTeachers() {
        List<UserInofDto> teachers = userService.findTeachersWithProfiles();
        return Result.success(teachers);
    }

    /**
     * 新增：根据用户ID获取其上传的所有资源
     * @param id 用户ID
     * @return 包含图文和视频的资源列表
     */
    @GetMapping("/{id}/resources")
    public Result<List<UserResourceDto>> getUserResources(@PathVariable Long id) {
        List<UserResourceDto> resources = userService.findResourcesByUserId(id);
        return Result.success(resources);
    }

}

