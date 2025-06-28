package org.csu.dao;

import org.csu.domain.HerbLocation;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * <p>
 * 药材地理分布(观测点)表 Mapper 接口
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Mapper
public interface HerbLocationDao extends BaseMapper<HerbLocation> {

}

