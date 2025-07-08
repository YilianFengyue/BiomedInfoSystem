package org.csu.service;

import com.baomidou.mybatisplus.extension.service.IService;
import org.csu.domain.CourseLesson;
import org.csu.dto.CreateLessonFromResourceDto;
import org.csu.dto.LessonDto;

public interface ICourseLessonService extends IService<CourseLesson> {
    LessonDto createLessonFromResource(Long chapterId, CreateLessonFromResourceDto createDto);

    /**
     * 删除一个课时
     * @param lessonId 要删除的课时ID
     */
    void deleteLesson(Long lessonId);
}