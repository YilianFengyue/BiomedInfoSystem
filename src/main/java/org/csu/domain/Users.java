package org.csu.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import java.io.Serializable;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
/**
 * <p>
 * 用户表 (简化版)
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Getter
@Setter
@ToString
public class Users implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 用户主键ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 用户名
     */
    private String username;

    /**
     * 角色 (e.g., student 1, teacher 2, admin 0 )
     */
    private int role;

    /**
     * 创建时间
     */
    private LocalDateTime createdAt;

    /**
     * 加盐哈希后的密码
     */
    private String passwordHash;

    /**
     * 账户状态 (1-正常, 2-禁用)
     */
    private Boolean status;

    /**
     * 更新时间
     */
    private LocalDateTime updatedAt;

    @TableField(exist = false) //这个字段在数据库表中不存在
    private boolean hasPassword;
}
