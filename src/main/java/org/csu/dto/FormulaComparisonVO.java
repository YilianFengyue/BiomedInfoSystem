package org.csu.dto;

import lombok.Data;
import java.util.List;
import java.util.Map;

@Data
public class FormulaComparisonVO {
    private List<FormulaDetailVO> formulas;
    private Map<String, List<String>> comparisonPoints;
} 