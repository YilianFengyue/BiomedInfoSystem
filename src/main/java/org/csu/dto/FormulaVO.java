package org.csu.dto;

import lombok.Data;

@Data
public class FormulaVO {
    private Long id;
    private String name;
    private String alias;
    private String source;
    private String dynasty;
    private String functionEffect;
    private String mainTreatment;
} 