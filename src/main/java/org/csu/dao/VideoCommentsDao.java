package org.csu.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.csu.domain.VideoComment;

@Mapper
public interface VideoCommentsDao extends BaseMapper<VideoComment> {
}