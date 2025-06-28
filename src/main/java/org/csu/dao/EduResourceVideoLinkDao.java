package org.csu.dao;

import org.csu.domain.EduResourceVideoLink;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import org.apache.ibatis.annotations.Mapper;

/**
 * <p>
 * 资源与视频的关联表 Mapper 接口
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Mapper
public interface EduResourceVideoLinkDao extends BaseMapper<EduResourceVideoLink> {

}

