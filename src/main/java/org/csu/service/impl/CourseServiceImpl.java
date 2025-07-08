package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.csu.dao.*;
import org.csu.domain.*;
import org.csu.dto.*;
import org.csu.service.ICourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class CourseServiceImpl extends ServiceImpl<CourseDao, Course> implements ICourseService {

    @Autowired
    private CourseChapterDao chapterDao;

    @Autowired
    private CourseLessonDao lessonDao;

    @Autowired
    private UsersDao usersDao; // 用于获取教师姓名

    @Override
    public CourseDetailDto getCourseWithChaptersAndLessons(Long courseId) {
        // 1. 获取课程主体信息
        Course course = this.getById(courseId);
        if (course == null) {
            return null;
        }

        // 2. 获取教师信息
        Users teacher = usersDao.selectById(course.getTeacherId());

        // 3. 构建课程DTO
        CourseDetailDto courseDto = new CourseDetailDto();
        courseDto.setId(course.getId());
        courseDto.setTitle(course.getTitle());
        courseDto.setCoverImage(course.getCoverImage());
        if (teacher != null) {
            courseDto.setTeacherName(teacher.getUsername());
        }

        // 4. 获取该课程下的所有章节
        List<CourseChapter> chapters = chapterDao.selectList(
                new LambdaQueryWrapper<CourseChapter>().eq(CourseChapter::getCourseId, courseId).orderByAsc(CourseChapter::getSortOrder)
        );

        if (chapters.isEmpty()) {
            return courseDto;
        }

        // 5. 遍历章节，获取每个章节下的所有课时
        List<ChapterDto> chapterDtos = chapters.stream().map(chapter -> {
            ChapterDto chapterDto = new ChapterDto();
            chapterDto.setId(chapter.getId());
            chapterDto.setTitle(chapter.getTitle());

            // 获取该章节下的所有课时
            List<CourseLesson> lessons = lessonDao.selectList(
                    new LambdaQueryWrapper<CourseLesson>().eq(CourseLesson::getChapterId, chapter.getId()).orderByAsc(CourseLesson::getSortOrder)
            );

            // 将课时实体转换为DTO
            List<LessonDto> lessonDtos = lessons.stream().map(lesson -> {
                LessonDto lessonDto = new LessonDto();
                lessonDto.setId(lesson.getId());
                lessonDto.setTitle(lesson.getTitle());
                lessonDto.setContentType(lesson.getContentType());
                lessonDto.setResourceUrl(lesson.getContentUrl());
                lessonDto.setDuration(lesson.getDuration());
                return lessonDto;
            }).collect(Collectors.toList());

            chapterDto.setLessons(lessonDtos);
            return chapterDto;
        }).collect(Collectors.toList());

        courseDto.setChapters(chapterDtos);

        return courseDto;
    }


    @Override
    public List<CourseListDto> getAllCourses() {
        // 1. 从数据库获取所有课程实体
        List<Course> courses = this.list();
        if (courses.isEmpty()) {
            return Collections.emptyList();
        }

        // 2. 为了优化性能，一次性获取所有相关的教师ID
        List<Long> teacherIds = courses.stream()
                .map(Course::getTeacherId)
                .distinct()
                .collect(Collectors.toList());

        // 3. 一次性查询所有教师信息，并存入Map以便快速查找
        Map<Long, Users> teacherMap = usersDao.selectBatchIds(teacherIds)
                .stream()
                .collect(Collectors.toMap(Users::getId, Function.identity()));

        // 4. 将课程实体(Course)列表映射为课程列表DTO(CourseListDto)
        List<CourseListDto> courseListDtos = courses.stream().map(course -> {
            CourseListDto dto = new CourseListDto();
            dto.setId(course.getId());
            dto.setTitle(course.getTitle());
            dto.setCoverImage(course.getCoverImage());
            dto.setStudentCount(course.getStudentCount());
            dto.setRating(course.getRating());

            // 从Map中查找并设置教师名称
            Users teacher = teacherMap.get(course.getTeacherId());
            if (teacher != null) {
                dto.setTeacherName(teacher.getUsername());
            } else {
                dto.setTeacherName("未知讲师"); // 作为兜底
            }
            return dto;
        }).collect(Collectors.toList());

        return courseListDtos;
    }

}