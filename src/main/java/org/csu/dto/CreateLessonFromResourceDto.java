package org.csu.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CreateLessonFromResourceDto {

    @NotBlank(message = "课时标题不能为空")
    private String title;

    @NotNull(message = "必须指定资源ID")
    private Long resourceId;

    @NotBlank(message = "必须指定资源类型 ('document' 或 'video')")
    private String contentType; // "document" for edu_resources, "video" for edu_videos
}