package org.csu.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

/**
 * 用于接收前端上传的图片及地点信息的DTO
 */
@Data
public class ImageUploadDto {

    // ===== 图片相关信息 =====
    @NotNull(message = "关联的药草ID不能为空")
    private Long herbId;

    @NotBlank(message = "图片URL不能为空")
    private String url;

    private Boolean isPrimary = false;

    private String description;

    // ===== 地点相关信息 =====
    @NotNull(message = "经度不能为空")
    private BigDecimal longitude;

    @NotNull(message = "纬度不能为空")
    private BigDecimal latitude;

    @NotBlank(message = "省份不能为空")
    private String province;

    private String city;

    private String address;

    @NotNull(message = "观测年份不能为空")
    private Integer observationYear;
} 