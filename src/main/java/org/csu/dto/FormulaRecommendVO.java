package org.csu.dto;

import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
public class FormulaRecommendVO {
    private Long formulaId;
    private String formulaName;
    private Double score;
    private List<String> matchedSymptoms;
    private String recommendation;
} 