package org.csu.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.csu.domain.Formula;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface FormulaDao extends BaseMapper<Formula> {
} 