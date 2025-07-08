package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.csu.config.BusinessException;
import org.csu.controller.Code;
import org.csu.dao.CourseChapterDao;
import org.csu.dao.CourseLessonDao;
import org.csu.domain.CourseChapter;
import org.csu.domain.CourseLesson;
import org.csu.service.ICourseChapterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 课程章节服务实现类
 */
@Service
public class CourseChapterServiceImpl extends ServiceImpl<CourseChapterDao, CourseChapter> implements ICourseChapterService {

    @Autowired
    private CourseLessonDao lessonDao;

    @Override
    @Transactional
    public void deleteChapter(Long chapterId) {
        // 1. 检查章节是否存在
        CourseChapter chapter = this.getById(chapterId);
        if (chapter == null) {
            throw new BusinessException(Code.DELETE_ERR, "删除失败：章节不存在，ID: " + chapterId);
        }

        // 2. 删除该章节下的所有课时
        lessonDao.delete(new LambdaQueryWrapper<CourseLesson>().eq(CourseLesson::getChapterId, chapterId));

        // 3. 删除章节本身
        this.removeById(chapterId);
    }
}