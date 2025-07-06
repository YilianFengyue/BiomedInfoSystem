package org.csu.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Setter
@Getter
public class CreateFormulaRequest {
    // Getters and Setters
    private String name;
    private String source;
    private String function;
    private List<HerbInfo> composition;
    private List<String> treatedDiseaseNames;

    public static class HerbInfo {
        private String name;
        private String dosage;
        private String role;
        // Getters and Setters
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getDosage() { return dosage; }
        public void setDosage(String dosage) { this.dosage = dosage; }
        public String getRole() { return role; }
        public void setRole(String role) { this.role = role; }
    }

}