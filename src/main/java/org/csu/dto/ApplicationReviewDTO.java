package org.csu.dto;

import lombok.Data;

@Data
public class ApplicationReviewDTO {
    private Long applicationId;
    private String action; // "approve" or "reject"
    private String reviewComment;
}
