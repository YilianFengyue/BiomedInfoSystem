// src/main/java/org/csu/dto/ResourceUploadDto.java
package org.csu.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ResourceUploadDto {

    @NotBlank(message = "标题不能为空")
    private String title;

    private String coverImageUrl;

    @NotNull(message = "必须指定作者ID")
    private Long authorId;

    private String status;

    @NotBlank(message = "必须指定资源类型")
    private String resourceType; // 'text' or 'video'

    // 图文资源字段
    private String content; // 富文本内容

    @NotNull(message = "必须关联一个分类")
    private Integer categoryId;

    // 视频资源字段
    private String description; // 视频简介

    private String videoUrl;

    private Integer duration;
}