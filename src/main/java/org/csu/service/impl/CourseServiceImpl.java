package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.csu.config.BusinessException;
import org.csu.controller.Code;
import org.csu.dao.*;
import org.csu.domain.*;
import org.csu.dto.*;
import org.csu.service.ICourseChapterService;
import org.csu.service.ICourseService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class CourseServiceImpl extends ServiceImpl<CourseDao, Course> implements ICourseService {

    @Autowired
    private ICourseChapterService courseChapterService; // 【修正】注入 Service 而不是 DAO


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


    @Override
    @Transactional // 使用事务确保课程和章节的创建是原子操作
    public CourseDetailDto createCourse(CourseCreateDto createDto) {
        // 1. 创建并保存Course实体
        Course course = new Course();
        BeanUtils.copyProperties(createDto, course);
        course.setStatus("published");
        this.save(course); // 'this' 指向 IService<Course>，调用save是正确的

        // 2. 遍历DTO中的章节信息，创建并保存CourseChapter实体
        if (createDto.getChapters() != null && !createDto.getChapters().isEmpty()) {
            List<CourseChapter> chaptersToSave = createDto.getChapters().stream().map(chapterDto -> {
                CourseChapter chapter = new CourseChapter();
                BeanUtils.copyProperties(chapterDto, chapter);
                chapter.setCourseId(course.getId());
                return chapter;
            }).collect(Collectors.toList());

            // 【修正】使用注入的 courseChapterService 来执行批量保存
            if (!chaptersToSave.isEmpty()) {
                courseChapterService.saveBatch(chaptersToSave);
            }
        }

        // 3. 返回新创建课程的完整详细信息
        return this.getCourseWithChaptersAndLessons(course.getId());
    }

    @Override
    @Transactional // 确保删除操作的原子性
    public void deleteCourse(Long courseId) {
        // 1. 检查课程是否存在
        Course course = this.getById(courseId);
        if (course == null) {
            throw new BusinessException(Code.DELETE_ERR, "删除失败：课程不存在，ID: " + courseId);
        }

        // 2. 删除该课程下的所有课时 (course_lesson)
        lessonDao.delete(new LambdaQueryWrapper<CourseLesson>().eq(CourseLesson::getCourseId, courseId));

        // 3. 删除该课程下的所有章节 (course_chapter)
        courseChapterService.remove(new LambdaQueryWrapper<CourseChapter>().eq(CourseChapter::getCourseId, courseId));

        // 4. 最后删除课程本身 (course)
        this.removeById(courseId);
    }
}