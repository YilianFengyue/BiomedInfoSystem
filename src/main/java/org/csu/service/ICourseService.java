package org.csu.service;

import com.baomidou.mybatisplus.extension.service.IService;
import org.csu.domain.Course;
import org.csu.dto.CourseDetailDto;
import org.csu.dto.CourseListDto;

import java.util.List;

public interface ICourseService extends IService<Course> { // IService<Course> 是MyBatis-Plus的功能
    CourseDetailDto getCourseWithChaptersAndLessons(Long courseId);

    /**
     * 获取所有课程的摘要信息列表
     * @return 包含课程摘要信息的DTO列表
     */
    List<CourseListDto> getAllCourses();
}