package org.csu.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.csu.domain.UserEvaluation;

@Mapper
public interface UserEvaluationDao extends BaseMapper<UserEvaluation> {
}