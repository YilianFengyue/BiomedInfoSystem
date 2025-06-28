package org.csu.dto;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 药材生长数据传输对象
 * 用于生长数据对比分析，包含地理位置和具体的生长指标
 * 
 * @author YilianFengyue
 */
@Data
public class HerbGrowthDataDto {
    /**
     * 生长数据记录ID
     */
    private Long growthDataId;

    /**
     * 观测点ID
     */
    private Long locationId;

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
     * 观测年份
     */
    private Integer observationYear;

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