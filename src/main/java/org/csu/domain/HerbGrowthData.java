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
 * 生长/统计数据表
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Getter
@Setter
@ToString
@TableName("herb_growth_data")
public class HerbGrowthData implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 外键：关联的观测点ID
     */
    private Long locationId;

    /**
     * 指标名称 (如: 产量, 平均株高)
     */
    private String metricName;

    /**
     * 指标值
     */
    private String metricValue;

    /**
     * 指标单位 (如: 公斤, 厘米)
     */
    private String metricUnit;

    /**
     * 记录时间
     */
    private LocalDateTime recordedAt;
}
