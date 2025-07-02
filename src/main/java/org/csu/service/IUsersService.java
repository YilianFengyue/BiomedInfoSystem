package org.csu.service;

import org.csu.domain.Users;
import com.baomidou.mybatisplus.extension.service.IService;
import org.csu.dto.UserInofDto;
import org.csu.dto.UserResourceDto;

import java.util.List;
import java.util.Map;

/**
 * <p>
 * 用户表 (简化版) 服务类
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
public interface IUsersService extends IService<Users> {
    Users findByUserName(String username);

    void register(String username, String password);


    void updatePwd(Long userId, String newHashedPassword);

    public Users findOrCreateUserByThirdParty(String provider, String providerUserId, Map<String, Object> attributes);

    /**
     * 新增：查询所有角色为教师的用户及其详细信息
     * @return 包含教师详细信息的DTO列表
     */
    List<UserInofDto> findTeachersWithProfiles();

    /**
     * 新增：根据用户ID获取其上传的所有资源（图文和视频）
     * @param userId 用户ID
     * @return 统一资源DTO列表
     */
    List<UserResourceDto> findResourcesByUserId(Long userId);

}
