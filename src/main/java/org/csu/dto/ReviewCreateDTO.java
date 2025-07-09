package org.csu.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class ReviewCreateDTO {
    private Long submissionId;
    private BigDecimal overallScore;
    private BigDecimal contentScore;
    private BigDecimal innovationScore;
    private BigDecimal methodologyScore;
    private BigDecimal writingScore;
    private String reviewComment;
    private String suggestions;
    private String reviewResult; // accept/minor_revision/major_revision/reject
    private Boolean isFinal;
}