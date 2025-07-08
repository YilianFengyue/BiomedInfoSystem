package org.csu.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.csu.dto.CourseDetailDto;
import org.csu.dto.CourseListDto;
import org.csu.service.ICourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/courses")
@CrossOrigin(origins = "*")
public class CourseController {

    @Autowired
    private ICourseService courseService;

    @GetMapping("/{id}")
    public Result<CourseDetailDto> getCourseDetails(@PathVariable Long id) {
        CourseDetailDto courseDetails = courseService.getCourseWithChaptersAndLessons(id);
        if (courseDetails == null) {
            return Result.error(Code.GET_ERR, "未找到该课程");
        }
        return Result.success(courseDetails);
    }

    /**
     * [新增] 获取所有课程的列表
     */
    @GetMapping
    @Operation(summary = "获取所有课程列表", description = "返回一个包含所有课程摘要信息的列表，用于课程中心或首页展示")
    public Result<List<CourseListDto>> getAllCourses() {
        List<CourseListDto> courses = courseService.getAllCourses();
        return Result.success(courses);
    }

}