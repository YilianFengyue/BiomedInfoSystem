package org.csu.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
/**
 * <p>
 * 药材图片表
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Getter
@Setter
@ToString
@TableName("herb_image")
public class HerbImage implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 外键：关联的药材ID
     */
    private Long herbId;

    /**
     * 【可选】外键：关联的观测点ID，用于现场实拍图
     */
    private Long locationId;

    /**
     * 图片地址URL
     */
    private String url;

    /**
     * 是否为主图 (0-否, 1-是)
     */
    private Boolean isPrimary;

    /**
     * 图片描述
     */
    private String description;

    /**
     * 上传时间
     */
    private LocalDateTime uploadedAt;
}
