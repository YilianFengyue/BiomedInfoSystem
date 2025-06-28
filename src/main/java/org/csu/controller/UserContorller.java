package org.csu.controller;


import org.csu.domain.UserProfiles;
import org.csu.domain.Users;
import org.csu.dto.UpdatePasswordDto;
import org.csu.service.IUserProfilesService;
import org.csu.service.IUsersService;
import org.csu.util.JWTUtil;
import org.csu.util.PasswordUtil;
import org.csu.util.ThreadLocalUtil;
import org.hibernate.validator.constraints.URL;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

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
                // --- 原有JWT逻辑开始 ---
                Map<String, Object> claims = new HashMap<>();
                claims.put("id", loginUser.getId());
                claims.put("username", loginUser.getUsername());
                String jwtToken = JWTUtil.genToken(claims);
                // 把JWT Token存储到Redis中 (这部分逻辑可以根据您的实际需求调整)
                ValueOperations<String, String> stringStringValueOperations = stringRedisTemplate.opsForValue();
                stringStringValueOperations.set(jwtToken, jwtToken, 12, TimeUnit.HOURS);
                // --- 原有JWT逻辑结束 ---


                // ================= 新增CSRF逻辑开始 =================

                // 1. 生成一个唯一的、不可预测的CSRF Token
                String csrfToken = UUID.randomUUID().toString().replace("-", "");

                // 2. 将CSRF Token存储到Redis中，与用户身份进行关联
                //    键的格式建议为 "csrf:用户ID"，这样清晰且不会冲突
                //    过期时间应与会话或JWT的过期时间保持一致或类似
                String csrfRedisKey = "csrf:" + loginUser.getId();
                stringRedisTemplate.opsForValue().set(csrfRedisKey, csrfToken, 12, TimeUnit.HOURS);

                // ================= 新增CSRF逻辑结束 =================


                // 3. 准备返回给前端的数据
                Map<String, String> responseData = new HashMap<>();
                responseData.put("token", jwtToken); // 这是JWT Token，用于身份认证
                responseData.put("csrf_token", csrfToken); // 这是CSRF Token，用于后续请求的安全验证

                // 4. 将包含两个Token的Map作为成功结果返回
                return new Result(LOGIN_OK,responseData,"登录成功");
            }
        }


    @GetMapping("/userInfo")
    public Result userinfo() {

        Map<String,Object> threadLocal = ThreadLocalUtil.getThreadLocal();
        int id = (int) threadLocal.get("id");
        UserProfiles userProfiles = userProfilesService.getById(id);
        System.out.println(userProfiles);

        return new Result(GET_OK,userProfiles,"获取成功");

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

        // 3. 校验原密码
        String storedPasswordHash = userService.getById(userId).getPasswordHash(); // 直接通过ID获取，更高效
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
}

