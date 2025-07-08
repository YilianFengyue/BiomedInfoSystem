package org.csu.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.csu.dao.UserEvaluationDao;
import org.csu.domain.UserEvaluation;
import org.csu.service.IUserEvaluationService;
import org.springframework.stereotype.Service;

@Service
public class UserEvaluationServiceImpl extends ServiceImpl<UserEvaluationDao, UserEvaluation> implements IUserEvaluationService {
}