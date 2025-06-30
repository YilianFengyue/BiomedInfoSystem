package org.csu.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ResourceListDto {
    // 用于列表页，信息可以简化
    private Long id;
    private String title;
    private Integer categoryId;
    private String categoryName;
    private String authorName;
    private String coverImageUrl;
    private String status;
    private LocalDateTime createdAt;
}