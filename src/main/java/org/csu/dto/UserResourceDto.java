package org.csu.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class UserResourceDto {

    private Long id;
    private String title;
    private String resourceType; // "text" 或 "video"
    private String coverImageUrl;
    private LocalDateTime createdAt;

    // 视频特有字段
    private Integer duration;
    private String videoUrl;

    // 图文特有字段
    private String categoryName;
}