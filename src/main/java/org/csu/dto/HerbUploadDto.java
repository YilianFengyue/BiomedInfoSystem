package org.csu.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal; // ✅ 导入 BigDecimal
import java.time.LocalDateTime;
import java.util.Map;

@Data
public class HerbUploadDto {

    @NotNull(message = "药材ID不能为空")
    private Long herbId;

    // --- 地理位置信息 ---
    // 将类型从 Double 修改为 BigDecimal
    @NotNull
    private BigDecimal longitude;
    @NotNull
    private BigDecimal latitude;

    @NotBlank
    private String province;
    private String city;
    @NotBlank
    private String address;
    private Integer observationYear;
    private String description;

    // --- 新增字段 ---
    private String uploaderName;
    private LocalDateTime uploadedAt;

    // --- 新增的生长数据字段 ---
    private Map<String, Object> growthData;
}