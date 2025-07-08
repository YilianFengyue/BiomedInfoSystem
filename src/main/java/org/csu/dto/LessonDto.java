package org.csu.dto;

import lombok.Data;

@Data
public class LessonDto {
    private Long id;
    private String title;
    private String contentType; // "video" 或 "document"
    private String resourceUrl; // 指向具体资源或视频的URL
    private Integer duration; // (可选) 视频时长
}