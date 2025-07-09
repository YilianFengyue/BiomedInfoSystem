package org.csu.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.csu.service.ICourseChapterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/chapters")
@Tag(name = "课程章节管理", description = "提供课程章节的独立管理功能")
@CrossOrigin(origins = "*")
public class CourseChapterController {

    @Autowired
    private ICourseChapterService chapterService;

    @DeleteMapping("/{id}")
    @Operation(summary = "删除章节", description = "根据ID删除一个章节及其所有课时")
    public Result<?> deleteChapter(@PathVariable Long id) {
        chapterService.deleteChapter(id);
        return Result.success("章节删除成功");
    }
}