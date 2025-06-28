package org.csu.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import java.io.Serializable;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
/**
 * <p>
 * 药材主信息表
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Getter
@Setter
@ToString
public class Herb implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 药材名称
     */
    private String name;

    /**
     * 学名
     */
    private String scientificName;

    /**
     * 科名
     */
    private String familyName;

    /**
     * 资源类型 (野生/栽培)
     */
    private String resourceType;

    /**
     * 生活型 (如: 乔木, 灌木, 多年生草本)
     */
    private String lifeForm;

    /**
     * 简介/药用价值描述
     */
    private String description;

    /**
     * 创建时间
     */
    private LocalDateTime createdAt;

    /**
     * 更新时间
     */
    private LocalDateTime updatedAt;
}
