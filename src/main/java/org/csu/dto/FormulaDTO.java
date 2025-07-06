package org.csu.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Map;

@Setter
@Getter
public class FormulaDTO {
    // Getters and Setters
    private Long id;
    private String name;
    private String source;
    private String function;
    private List<Map<String, String>> composition;
    private List<String> treatedDiseases;

}