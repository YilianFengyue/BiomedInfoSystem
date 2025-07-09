package org.csu.dto;

import lombok.Data;

@Data
public class ProjectStatDTO {
    private Long projectId;
    private String projectName;
    private Integer totalTasks;
    private Integer completedTasks;
    private Integer totalMembers;
    private Integer totalSubmissions;
    private Integer approvedSubmissions;
    private String progressStatus;
    private Double completionRate;
}