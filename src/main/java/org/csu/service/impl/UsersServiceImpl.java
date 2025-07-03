package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.csu.config.BusinessException;
import org.csu.controller.Code;
import org.csu.dao.EduCategoriesDao;
import org.csu.dao.EduResourcesDao;
import org.csu.dao.EduVideosDao;
import org.csu.domain.*;
import org.csu.dao.UsersDao;
import org.csu.dto.UserInofDto;
import org.csu.dto.UserResourceDto;
import org.csu.service.IUserProfilesService;
import org.csu.service.IUserThirdPartyAuthService;
import org.csu.service.IUsersService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.csu.util.PasswordUtil;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * <p>
 * 用户表 (简化版) 服务实现类
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Service
public class UsersServiceImpl extends ServiceImpl<UsersDao, Users> implements IUsersService {

    @Autowired
    private IUserProfilesService userProfilesService;

    @Autowired
    private IUserThirdPartyAuthService thirdPartyAuthService;

    @Autowired
    private EduResourcesDao eduResourcesDao;

    @Autowired
    private EduVideosDao eduVideosDao;

    @Autowired
    private EduCategoriesDao eduCategoriesDao;


    @Override
    public Users findByUserName(String username) {
        // 1. 创建一个查询条件构造器 (LambdaQueryWrapper)
        LambdaQueryWrapper<Users> queryWrapper = new LambdaQueryWrapper<>();

        // 2. 添加查询条件：username 字段等于传入的 username 参数
        //    使用 Users::getUsername 方法引用可以防止硬编码字段名，更安全
        queryWrapper.eq(Users::getUsername, username);

        // 3. 调用 baseMapper 的 selectOne 方法执行查询
        //    baseMapper 是 ServiceImpl 中自带的，可以直接使用
        //    如果找到一个匹配的用户，则返回该对象；如果找不到或找到多个，则返回null（或抛出异常，取决于配置）
        Users user = this.baseMapper.selectOne(queryWrapper);
        if (user != null) {
            // 检查密码哈希是否是我们的特殊占位符
            boolean hasPasswordSet = !"OAUTH2_USER".equals(user.getPasswordHash());
            user.setHasPassword(hasPasswordSet);
        }
        return user;
    }

    @Override
    public void register(String username, String password) {
        Users user = new Users();

        user.setUsername(username);

        String Password= PasswordUtil.hashPassword(password);
        user.setPasswordHash(Password);

        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());

        this.save(user);

        Long newUserId = user.getId();
        if (newUserId == null) {
            throw new RuntimeException("注册失败，无法获取用户ID。");
        }

        UserProfiles userProfile = new UserProfiles();
        userProfile.setUserId(newUserId);

        // 设置一个默认的昵称，例如使用用户名作为初始昵称
        userProfile.setNickname(username);
        userProfilesService.save(userProfile);

    }


    @Override
    public void updatePwd(Long userId, String newHashedPassword) {
        // 1. 创建一个只包含主键和待更新字段的实体对象
        Users userToUpdate = new Users();
        userToUpdate.setId(userId);
        userToUpdate.setPasswordHash(newHashedPassword);

        // 2. 调用 MyBatis-Plus 的 updateById 方法执行部分更新
        this.updateById(userToUpdate);
    }



    @Override
    @Transactional // 保证用户创建和绑定是原子操作，要么都成功，要么都回滚
    public Users findOrCreateUserByThirdParty(String provider, String providerUserId, Map<String, Object> attributes) {
        // 1. 根据 provider 和 providerUserId 查询绑定记录是否存在
        UserThirdPartyAuth thirdPartyAuth = thirdPartyAuthService.getOne(
                new LambdaQueryWrapper<UserThirdPartyAuth>()
                        .eq(UserThirdPartyAuth::getProvider, provider)
                        .eq(UserThirdPartyAuth::getProviderUserId, providerUserId)
        );

        if (thirdPartyAuth != null) {
            // 如果绑定记录存在，说明是老用户，直接返回我们系统内的用户信息
            return this.getById(thirdPartyAuth.getUserId());
        }

        // 2. 如果不存在，说明是新用户，需要创建一系列新记录
        // a. 在 `users` 表中创建主用户
        Users newUser = new Users();
        String username = (String) attributes.get("login"); // "login" 是 GitHub 返回的用户名键
        newUser.setUsername(provider + "_" + username); // 加个前缀防止和普通注册用户重名
        newUser.setPasswordHash("OAUTH2_USER"); // 第三方登录用户没有密码，设置一个特殊标识
        newUser.setCreatedAt(LocalDateTime.now());
        // ... 设置其他必要的默认值，如 role, status, create_at 等
        this.save(newUser); // 保存后，newUser 对象会获得数据库生成的 ID

        // 2. 在 `user_profiles` 表中创建用户档案记录
        UserProfiles newProfile = new UserProfiles();

        // a. 关联主用户 ID
        newProfile.setUserId(newUser.getId());

        // b. 从 GitHub 返回的 attributes 中提取并设置档案信息
        newProfile.setNickname((String) attributes.get("name")); // GitHub 用户的显示名称
        newProfile.setAvatarUrl((String) attributes.get("avatar_url")); // GitHub 头像地址
        newProfile.setBio((String) attributes.get("bio")); // GitHub 个人简介


        // c. 执行保存
        userProfilesService.save(newProfile);

        // b. 在 `user_profiles` 表中创建用户档案
        // ... (根据需要，创建并保存 UserProfiles 对象) ...

        // c. 在 `user_third_party_auths` 表中创建绑定关系
        UserThirdPartyAuth newThirdPartyAuth = new UserThirdPartyAuth();
        newThirdPartyAuth.setUserId(newUser.getId());
        newThirdPartyAuth.setProvider(provider);
        newThirdPartyAuth.setProviderUserId(providerUserId);
        thirdPartyAuthService.save(newThirdPartyAuth);

        return newUser;
    }

    /**
     * 新增方法的实现
     */
    @Override
    @Transactional(readOnly = true) // 只读事务，提高查询性能
    public List<UserInofDto> findTeachersWithProfiles() {
        // 1. 查询所有角色为教师的用户 (role=2)
        LambdaQueryWrapper<Users> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Users::getRole, 2);
        List<Users> teachers = this.list(queryWrapper);

        if (teachers.isEmpty()) {
            return Collections.emptyList(); // 如果没有教师，直接返回空列表
        }

        // 2. 提取所有教师的ID
        List<Long> teacherIds = teachers.stream().map(Users::getId).collect(Collectors.toList());

        // 3. 一次性查询所有教师的个人资料
        Map<Long, UserProfiles> profilesMap = userProfilesService.listByIds(teacherIds).stream()
                .collect(Collectors.toMap(UserProfiles::getUserId, Function.identity()));

        // 4. 组装DTO列表
        return teachers.stream().map(teacher -> {
            UserInofDto dto = new UserInofDto();
            // 复制Users表中的基础信息
            BeanUtils.copyProperties(teacher, dto);

            // 从Map中获取并填充UserProfiles表中的信息
            UserProfiles profile = profilesMap.get(teacher.getId());
            if (profile != null) {
                dto.setNickname(profile.getNickname());
                dto.setAvatarUrl(profile.getAvatarUrl());
                dto.setBio(profile.getBio());
            }
            return dto;
        }).collect(Collectors.toList());
    }


    @Override
    public List<UserResourceDto> findResourcesByUserId(Long userId) {
        List<UserResourceDto> combinedResources = new ArrayList<>();

        // 1. 查询图文资源
        LambdaQueryWrapper<EduResources> resourcesQuery = new LambdaQueryWrapper<>();
        resourcesQuery.eq(EduResources::getAuthorId, userId);
        List<EduResources> textResources = eduResourcesDao.selectList(resourcesQuery);

        // 如果有图文资源，处理并添加到列表
        if (textResources != null && !textResources.isEmpty()) {
            // 批量获取分类信息以优化性能
            List<Integer> categoryIds = textResources.stream()
                    .map(EduResources::getCategoryId)
                    .distinct()
                    .collect(Collectors.toList());
            Map<Integer, String> categoryMap = eduCategoriesDao.selectBatchIds(categoryIds).stream()
                    .collect(Collectors.toMap(EduCategories::getId, EduCategories::getName));

            List<UserResourceDto> textDtos = textResources.stream().map(res -> {
                UserResourceDto dto = new UserResourceDto();
                dto.setId(res.getId());
                dto.setTitle(res.getTitle());
                dto.setResourceType("text");
                dto.setCoverImageUrl(res.getCoverImageUrl());
                dto.setCreatedAt(res.getCreatedAt());
                dto.setCategoryName(categoryMap.get(res.getCategoryId()));
                return dto;
            }).collect(Collectors.toList());
            combinedResources.addAll(textDtos);
        }


        // 2. 查询视频资源
        LambdaQueryWrapper<EduVideos> videosQuery = new LambdaQueryWrapper<>();
        videosQuery.eq(EduVideos::getUploaderId, userId);
        List<EduVideos> videoResources = eduVideosDao.selectList(videosQuery);

        if (videoResources != null && !videoResources.isEmpty()) {
            List<UserResourceDto> videoDtos = videoResources.stream().map(vid -> {
                UserResourceDto dto = new UserResourceDto();
                dto.setId(vid.getId());
                dto.setTitle(vid.getTitle());
                dto.setResourceType("video");
                dto.setCoverImageUrl(vid.getCoverUrl());
                dto.setCreatedAt(vid.getCreatedAt());
                dto.setDuration(vid.getDuration());
                dto.setVideoUrl(vid.getVideoUrl());
                return dto;
            }).collect(Collectors.toList());
            combinedResources.addAll(videoDtos);
        }

        // 3. 按创建时间降序排序
        combinedResources.sort((o1, o2) -> o2.getCreatedAt().compareTo(o1.getCreatedAt()));

        return combinedResources;
    }

    @Override
    @Transactional(readOnly = true) // 只读事务，提高查询性能
    public List<UserInofDto> findAllUsersWithProfiles() {
        // 1. 查询所有用户
        List<Users> allUsers = this.list();

        if (allUsers.isEmpty()) {
            return Collections.emptyList(); // 如果没有用户，直接返回空列表
        }

        // 2. 提取所有用户的ID
        List<Long> userIds = allUsers.stream().map(Users::getId).collect(Collectors.toList());

        // 3. 一次性查询所有用户的个人资料
        Map<Long, UserProfiles> profilesMap = userProfilesService.listByIds(userIds).stream()
                .collect(Collectors.toMap(UserProfiles::getUserId, Function.identity()));

        // 4. 组装DTO列表
        return allUsers.stream().map(user -> {
            UserInofDto dto = new UserInofDto();
            // 复制Users表中的基础信息
            BeanUtils.copyProperties(user, dto);

            // 从Map中获取并填充UserProfiles表中的信息
            UserProfiles profile = profilesMap.get(user.getId());
            if (profile != null) {
                dto.setNickname(profile.getNickname());
                dto.setAvatarUrl(profile.getAvatarUrl());
                dto.setBio(profile.getBio());
            }
            return dto;
        }).collect(Collectors.toList());
    }

    /**
     * 新增：重置密码的实现
     */
    @Override
    @Transactional
    public void resetPassword(Long userId) {
        // 1. 检查用户是否存在
        Users user = this.getById(userId);
        if (user == null) {
            throw new BusinessException(Code.UPDATE_ERR, "用户不存在，无法重置密码");
        }

        // 2. 定义默认密码并哈希
        String defaultPassword = "012345";
        String hashedDefaultPassword = PasswordUtil.hashPassword(defaultPassword);

        // 3. 调用已有的密码更新方法
        this.updatePwd(userId, hashedDefaultPassword);
    }

    /**
     * 新增：修改用户角色的实现
     */
    @Override
    @Transactional
    public void updateUserRole(Long userId, int newRole) {
        // 1. 检查用户是否存在
        Users user = this.getById(userId);
        if (user == null) {
            throw new BusinessException(Code.UPDATE_ERR, "用户不存在，无法修改角色");
        }

        // 2. 创建一个只包含ID和待更新role字段的实体
        Users userToUpdate = new Users();
        userToUpdate.setId(userId);
        userToUpdate.setRole(newRole);

        // 3. 执行部分更新
        this.updateById(userToUpdate);
    }
}
