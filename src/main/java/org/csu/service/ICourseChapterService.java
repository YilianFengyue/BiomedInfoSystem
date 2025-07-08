package org.csu.service;

import com.baomidou.mybatisplus.extension.service.IService;
import org.csu.domain.CourseChapter;

/**
 * 课程章节服务接口
 */
public interface ICourseChapterService extends IService<CourseChapter> {
    // 未来可以在这里扩展更多与章节相关的业务方法

    /**
     * 删除一个章节及其下属的所有课时
     * @param chapterId 要删除的章节ID
     */
    void deleteChapter(Long chapterId);
}