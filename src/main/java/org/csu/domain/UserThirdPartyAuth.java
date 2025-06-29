package org.csu.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;

/**
 * 用户第三方授权绑定实体类
 * <p>
 * 这张表是核心的关联枢纽，记录了哪个第三方平台的用户，
 * 对应我们自己系统里的哪个用户。
 */
@Data
@TableName("user_third_party_auths")
public class UserThirdPartyAuth implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 绑定记录的自增主键ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 关联到我们自己系统 users 表的 user_id
     */
    private Long userId;

    /**
     * 第三方平台标识 (例如: 'github', 'wechat', 'google')
     */
    private String provider;

    /**
     * 用户在第三方平台上的唯一ID
     */
    private String providerUserId;
}