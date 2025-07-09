package org.csu.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class ProjectVO {
    private Long id;
    private String projectName;
    private String projectCode;
    private String projectType;
    private String fundingSource;
    private BigDecimal fundingAmount;
    private String principalInvestigatorName;
    private LocalDate startDate;
    private LocalDate endDate;
    private String status;
    private String researchField;
    private LocalDateTime createdAt;
    private Integer memberCount;
    private Integer taskCount;
}