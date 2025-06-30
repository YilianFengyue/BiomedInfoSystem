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
    private LocalDateTime createdAt;
}
