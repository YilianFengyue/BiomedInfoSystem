package org.csu.dto;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class ResourceDetailDto {
    private Long id;
    private String title;
    private Integer categoryId;
    private String categoryName; // 连表查询出的分类名
    private Long authorId;
    private String authorName; // 连表查询出的作者名
    private String coverImageUrl;
    private String content;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime publishedAt;
    private List<VideoInfoDto> videos; // 关联的视频列表
}
