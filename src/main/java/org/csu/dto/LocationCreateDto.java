package org.csu.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class LocationCreateDto {

    @NotNull(message = "关联的药草ID不能为空")
    private Long herbId;

    @NotNull(message = "经度不能为空")
    private Double longitude;

    @NotNull(message = "纬度不能为空")
    private Double latitude;

    @NotNull(message = "省份不能为空")
    private String province;

    private String city;

    private String address;

    @NotNull(message = "观测年份不能为空")
    private Integer observationYear;

    private String description;
} 