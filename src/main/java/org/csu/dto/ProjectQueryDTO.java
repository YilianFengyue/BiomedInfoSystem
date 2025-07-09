package org.csu.dto;

import lombok.Data;

@Data
public class ProjectQueryDTO {
    private String keyword;
    private String projectType;
    private String status;
    private String researchField;
}