package org.csu.dto;

import lombok.Data;
import java.time.LocalDate;

@Data
public class TaskCreateDTO {
    private Long projectId;
    private Long studentId;
    private String title;
    private String description;
    private String requirements;
    private LocalDate deadline;
    private String priority;
}