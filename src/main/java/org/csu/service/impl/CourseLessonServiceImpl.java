package org.csu.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.csu.config.BusinessException;
import org.csu.controller.Code;
import org.csu.dao.*;
import org.csu.domain.*;
import org.csu.dto.CreateLessonFromResourceDto;
import org.csu.dto.LessonDto;
import org.csu.service.ICourseLessonService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CourseLessonServiceImpl extends ServiceImpl<CourseLessonDao, CourseLesson> implements ICourseLessonService {

    @Autowired
    private CourseChapterDao chapterDao;
    @Autowired
    private EduResourcesDao resourcesDao;
    @Autowired
    private EduVideosDao videosDao;

    @Override
    @Transactional
    public LessonDto createLessonFromResource(Long chapterId, CreateLessonFromResourceDto createDto) {
        // 1. 校验目标章节是否存在
        CourseChapter chapter = chapterDao.selectById(chapterId);
        if (chapter == null) {
            throw new BusinessException(Code.SAVE_ERR, "创建失败：目标章节不存在，ID: " + chapterId);
        }

        CourseLesson lesson = new CourseLesson();
        lesson.setChapterId(chapterId);
        lesson.setCourseId(chapter.getCourseId());
        lesson.setTitle(createDto.getTitle());
        lesson.setContentType(createDto.getContentType());
        lesson.setSortOrder(0);

        // 2. 根据资源类型，校验资源是否存在并构建content_url
        if ("document".equalsIgnoreCase(createDto.getContentType())) {
            EduResources resource = resourcesDao.selectById(createDto.getResourceId());
            if (resource == null) {
                throw new BusinessException(Code.SAVE_ERR, "创建失败：关联的图文资源不存在，ID: " + createDto.getResourceId());
            }
            // 创建一个指向图文资源详情页的内部链接
            lesson.setContentUrl("resource-detail/" + resource.getId());
        } else if ("video".equalsIgnoreCase(createDto.getContentType())) {
            EduVideos video = videosDao.selectById(createDto.getResourceId());
            if (video == null) {
                throw new BusinessException(Code.SAVE_ERR, "创建失败：关联的视频资源不存在，ID: " + createDto.getResourceId());
            }
            // 创建一个指向视频资源详情页的内部链接
            lesson.setContentUrl("VideoDetail/" + video.getId());
            lesson.setDuration(video.getDuration());
        } else {
            throw new BusinessException(Code.VALIDATE_ERR, "无效的资源类型，必须是 'document' 或 'video'");
        }

        // 3. 保存新的课时记录
        this.save(lesson);

        // 4. 将新创建的课时实体转换为DTO并返回
        LessonDto lessonDto = new LessonDto();
        BeanUtils.copyProperties(lesson, lessonDto);
        lessonDto.setResourceUrl(lesson.getContentUrl());

        return lessonDto;
    }
}