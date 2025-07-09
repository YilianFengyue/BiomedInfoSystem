package org.csu.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class CourseCreateDto {

    @NotBlank(message = "课程标题不能为空")
    private String title;

    @NotNull(message = "必须指定课程分类")
    private Integer categoryId;

    @NotNull(message = "必须指定教师ID")
    private Long teacherId;

    private String coverImage;
    private String introduction;

    // 嵌套校验，确保章节列表中的每个元素都符合ChapterCreateDto的规则
    @Valid
    private List<ChapterCreateDto> chapters;
}