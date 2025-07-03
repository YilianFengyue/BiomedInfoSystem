// 文件路径: src/main/java/org/csu/dto/VideoDto.java
package org.csu.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class VideoDto {
    private Long id;
    @NotBlank
    private String title;
    private String description;
    @NotBlank
    private String videoUrl; // 来自OSS的URL
    private String coverUrl;
    private Integer duration; // 单位：秒
    private Long uploaderId;
    private String uploaderName;

    // 【新增】添加status字段以匹配后端实体和前端需求
    private String status;

    private LocalDateTime createdAt;
}
