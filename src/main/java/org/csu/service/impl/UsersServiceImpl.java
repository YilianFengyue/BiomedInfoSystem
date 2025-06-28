package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.csu.domain.UserProfiles;
import org.csu.domain.Users;
import org.csu.dao.UsersDao;
import org.csu.service.IUserProfilesService;
import org.csu.service.IUsersService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.csu.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

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
        return this.baseMapper.selectOne(queryWrapper);
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
}
