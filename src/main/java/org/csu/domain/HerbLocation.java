package org.csu.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
/**
 * <p>
 * 药材地理分布(观测点)表
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Getter
@Setter
@ToString
@TableName("herb_location")
public class HerbLocation implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 主键ID, 代表一次唯一的观测记录
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 外键：关联的药材ID
     */
    private Long herbId;

    /**
     * 经度 (e.g., 116.404269)
     */
    private BigDecimal longitude;

    /**
     * 纬度 (e.g., 39.913169)
     */
    private BigDecimal latitude;

    /**
     * 省份
     */
    private String province;

    /**
     * 城市
     */
    private String city;

    /**
     * 详细地址/地名
     */
    private String address;

    /**
     * 观测/采集年份
     */
    private Integer observationYear;

    /**
     * 记录创建时间
     */
    private LocalDateTime createdAt;
}
