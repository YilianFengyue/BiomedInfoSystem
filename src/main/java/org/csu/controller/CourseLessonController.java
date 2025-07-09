package org.csu.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.csu.dto.CreateLessonFromResourceDto;
import org.csu.dto.LessonDto;
import org.csu.service.ICourseLessonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/lessons") // 将基础路径改为 /lessons
@Tag(name = "课程课时管理", description = "管理课程章节下的具体课时")
@CrossOrigin(origins = "*")
public class CourseLessonController {

    @Autowired
    private ICourseLessonService lessonService;

    /**
     * 【修改】为了接口更RESTful，将创建接口也移到这里
     * 原接口：POST /chapters/{chapterId}/lessons
     * 新接口：POST /lessons?chapterId={chapterId}
     */
    @PostMapping
    @Operation(summary = "从已有资源创建新课时", description = "将一个已存在的图文或视频资源添加为指定章节下的一个课时")
    public Result<LessonDto> addLessonFromResource(
            @RequestParam Long chapterId, // 改为使用 @RequestParam
            @Valid @RequestBody CreateLessonFromResourceDto createDto) {

        LessonDto createdLesson = lessonService.createLessonFromResource(chapterId, createDto);
        return Result.success(createdLesson, "课时添加成功");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除课时", description = "根据ID删除一个课时")
    public Result<?> deleteLesson(@PathVariable Long id) {
        lessonService.deleteLesson(id);
        return Result.success("课时删除成功");
    }
}