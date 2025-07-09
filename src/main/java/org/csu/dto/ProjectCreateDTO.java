package org.csu.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class ProjectCreateDTO {
    private String projectName;
    private String projectCode;
    private String projectType;
    private String fundingSource;
    private BigDecimal fundingAmount;
    private LocalDate startDate;
    private LocalDate endDate;
    private String abstractText;
    private String keywords;
    private String researchField;
}