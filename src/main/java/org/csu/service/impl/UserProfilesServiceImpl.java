package org.csu.service.impl;

import org.csu.domain.UserProfiles;
import org.csu.dao.UserProfilesDao;
import org.csu.service.IUserProfilesService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 用户信息表 服务实现类
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Service
public class UserProfilesServiceImpl extends ServiceImpl<UserProfilesDao, UserProfiles> implements IUserProfilesService {

}
