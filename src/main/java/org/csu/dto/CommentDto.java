package org.csu.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class CommentDto {
    private Long id;
    private String content;
    private Long userId;
    private String authorName;
    private String avatarUrl;
    private LocalDateTime createdAt;
    private Long parentId;
}