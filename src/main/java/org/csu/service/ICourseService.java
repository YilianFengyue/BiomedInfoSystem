package org.csu.service;

import com.baomidou.mybatisplus.extension.service.IService;
import org.csu.domain.Course;
import org.csu.dto.CourseCreateDto;
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

    /**
     * 创建一个新课程，并同时创建其下的章节
     *
     * @param createDto 包含课程和章节信息的DTO
     * @return 创建成功后的课程详细信息DTO
     */
    CourseDetailDto createCourse(CourseCreateDto createDto);

    /**
     * 删除一个课程及其下属的所有章节和课时
     * @param courseId 要删除的课程ID
     */
    void deleteCourse(Long courseId);
}