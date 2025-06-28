package org.csu.domain;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
/**
 * <p>
 * 用户信息表
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Getter
@Setter
@ToString
@TableName("user_profiles")
public class UserProfiles implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 用户ID, 外键关联users.id
     */
    @TableId("user_id")
    private Long userId;

    /**
     * 用户昵称
     */
    private String nickname;

    /**
     * 头像URL
     */
    private String avatarUrl;

    /**
     * 性别
     */
    private String gender;

    /**
     * 个人简介
     */
    private String bio;
}
