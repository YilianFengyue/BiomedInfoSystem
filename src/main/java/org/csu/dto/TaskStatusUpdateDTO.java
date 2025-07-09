package org.csu.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class TaskStatusUpdateDTO {
    private String status;
    private BigDecimal progress;
    private String progressNote;
}