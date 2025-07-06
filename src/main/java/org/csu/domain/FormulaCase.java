package org.csu.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.sql.Date;
import java.sql.Timestamp;

@Data
@TableName("formula_case")
public class FormulaCase {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long formulaId;
    private String caseTitle;
    private String patientInfo;
    private String chiefComplaint;
    private String historyPresent;
    private String physicalExam;
    private String tonguePulse;
    private String tcmDiagnosis;
    private String treatmentPrinciple;
    private String prescription;
    private String followUp;
    private String outcome;
    private String doctorName;
    private String hospital;
    private Date caseDate;
    private String source;
    private Timestamp createdAt;
} 