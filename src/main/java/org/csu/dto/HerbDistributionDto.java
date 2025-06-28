package org.csu.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.math.BigDecimal;

/**
 * 药材地理分布数据传输对象
 * 用于地图可视化，包含药材在各个观测点的地理坐标信息
 * 
 * @author YilianFengyue
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class HerbDistributionDto {
    
    /**
     * 观测点ID
     */
    private Long locationId;
    
    /**
     * 药材ID
     */
    private Long herbId;
    
    /**
     * 药材名称
     */
    private String herbName;
    
    /**
     * 详细地址/地名
     */
    private String address;
    
    /**
     * 经度
     */
    private BigDecimal longitude;
    
    /**
     * 纬度
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
     * 观测/采集年份
     */
    private Integer observationYear;
} 