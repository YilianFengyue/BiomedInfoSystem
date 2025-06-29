package org.csu.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class HerbDto {

    @NotBlank(message = "药材名称不能为空")
    private String name;

    private String scientificName;

    private String familyName;

    private String description;

    private String medicinalParts;

    private String traditionalUses;

    private String chemicalComposition;

    @NotBlank(message = "资源类型不能为空")
    private String resourceType; // e.g., '野生', '栽培'
} 