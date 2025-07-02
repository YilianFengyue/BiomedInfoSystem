package org.csu.dto;

import lombok.Data;

@Data
public class TeacherScoreDto {
    private Long teacherId;
    private String teacherName;
    private Double score;
    private Integer totalLikes;
    private Long totalVideoDuration; // in seconds
    private Long totalResources;
} 