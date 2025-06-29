package org.csu.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.csu.dao.UserThirdPartyAuthDao;
import org.csu.domain.UserThirdPartyAuth;
import org.csu.service.IUserThirdPartyAuthService;
import org.springframework.stereotype.Service;

@Service
public class UserThirdPartyAuthServiceImpl extends ServiceImpl<UserThirdPartyAuthDao, UserThirdPartyAuth> implements IUserThirdPartyAuthService {

}