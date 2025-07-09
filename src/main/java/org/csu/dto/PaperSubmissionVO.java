package org.csu.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class PaperSubmissionVO {
    private Long id;
    private String title;
    private String studentName;
    private String taskTitle;
    private String status;
    private Integer version;
    private String fileUrl;
    private Long fileSize;
    private LocalDateTime submissionTime;
}