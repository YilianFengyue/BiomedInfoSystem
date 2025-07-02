package org.csu.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.csu.domain.VideoLike;

@Mapper
public interface VideoLikesDao extends BaseMapper<VideoLike> {
}