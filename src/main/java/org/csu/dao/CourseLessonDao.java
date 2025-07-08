package org.csu.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.csu.domain.CourseLesson;

@Mapper
public interface CourseLessonDao extends BaseMapper<CourseLesson> {
}