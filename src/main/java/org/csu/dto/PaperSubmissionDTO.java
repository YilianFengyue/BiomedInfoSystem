package org.csu.dto;

import lombok.Data;

@Data
public class PaperSubmissionDTO {
    private Long taskId;
    private String title;
    private String abstractText;
    private String keywords;
    private String fileUrl;
    private String fileName;
    private Long fileSize;
    private String submissionNotes;
}