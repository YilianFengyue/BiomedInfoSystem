package org.csu.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ChapterCreateDto {
    @NotBlank(message = "章节标题不能为空")
    private String title;

    private String description;

    private int sortOrder = 0;
}