package org.csu.dao;

import org.csu.domain.HerbGrowthData;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import org.apache.ibatis.annotations.Mapper;

/**
 * <p>
 * 生长/统计数据表 Mapper 接口
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Mapper
public interface HerbGrowthDataDao extends BaseMapper<HerbGrowthData> {

}

