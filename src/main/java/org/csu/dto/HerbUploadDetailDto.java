// src/main/java/org/csu/dto/HerbUploadDetailDto.java

package org.csu.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 用于展示药材上传详情的DTO，包含了所有关联信息
 */
@Data
@JsonInclude(JsonInclude.Include.NON_NULL) // 返回JSON时不包含null值的字段
public class HerbUploadDetailDto {

    private Long locationId;

    // --- 药材基础信息 ---
    private Long herbId;
    private String herbName;

    // --- 地理位置信息 ---
    private BigDecimal longitude;
    private BigDecimal latitude;
    private String province;
    private String city;
    private String address;
    private Integer observationYear;
    private String description;

    // --- 上传者与时间信息 ---
    private String uploaderName;
    private LocalDateTime uploadedAt;

    // --- 关联数据 ---
    private List<Map<String, Object>> growthData; // 包含多个生长指标
    private List<String> imageUrls; // 包含多张图片
}