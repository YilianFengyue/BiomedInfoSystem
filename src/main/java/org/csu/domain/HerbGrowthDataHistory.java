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
 * 生长/统计数据变更历史表
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Getter
@Setter
@ToString
@TableName("herb_growth_data_history")
public class HerbGrowthDataHistory implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 历史记录主键ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 原数据表的主键ID
     */
    private Long originId;

    /**
     * 关联的观测点ID
     */
    private Long locationId;

    /**
     * 指标名称
     */
    private String metricName;

    /**
     * 变更前的值
     */
    private String oldValue;

    /**
     * 变更后的值
     */
    private String newValue;

    /**
     * 操作类型 (如: CREATE, UPDATE, DELETE)
     */
    private String action;

    /**
     * 操作人
     */
    private String changedBy;

    /**
     * 变更时间
     */
    private LocalDateTime changedAt;

    /**
     * 变更备注
     */
    private String remark;
}
