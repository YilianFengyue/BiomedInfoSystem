package org.csu.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CommentCreateDto {
    @NotNull(message = "用户ID不能为空")
    private Long userId;

    @NotBlank(message = "留言内容不能为空")
    private String content;

    private Long parentId;
}