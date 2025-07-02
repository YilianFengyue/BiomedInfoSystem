package org.csu.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.csu.domain.VideoLike;

import java.util.List;

@Mapper
public interface VideoLikesDao extends BaseMapper<VideoLike> {
    Integer countByVideoIds(@Param("videoIds") List<Long> videoIds);
}