package org.csu.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class TaskVO {
    private Long id;
    private String title;
    private String description;
    private String studentName;
    private String projectName;
    private LocalDate deadline;
    private String priority;
    private String status;
    private BigDecimal progress;
    private LocalDateTime createdAt;
}
