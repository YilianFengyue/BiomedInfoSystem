package org.csu.dto;

import lombok.Data;

@Data
public class FormulaDetailVO {
    private Long id;
    private String name;
    private String alias;
    private String source;
    private String dynasty;
    private String author;
    private Integer categoryId;
    private String composition;
    private String preparation;
    private String usage;
    private String dosageForm;
    private String functionEffect;
    private String mainTreatment;
    private String clinicalApplication;
    private String pharmacologicalAction;
    private String contraindication;
    private String caution;
    private String modernResearch;
    private String remarks;
} 