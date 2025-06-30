package org.csu.dto;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class UserInofDto {
    // --- 来自 users 表 ---
    @Schema(description = "用户主键ID", example = "1001")
    private Long id;

    @Schema(description = "登录用户名", example = "john_doe")
    private String username;

    @Schema(description = "用户角色", example = "USER")
    private int role;

    @Schema(description = "账户创建时间")
    private LocalDateTime createdAt;

    // --- 来自 user_profiles 表 ---
    @Schema(description = "用户昵称", example = "约翰")
    private String nickname;

    @Schema(description = "个人头像URL", example = "https://example.com/avatar.jpg")
    private String avatarUrl;

    @Schema(description = "个人简介", example = "一位热爱探索的开发者。")
    private String bio;
}
