package org.csu.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.sql.Timestamp;

@Data
@TableName("formula_disease")
public class FormulaDisease {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long formulaId;
    private String diseaseName;
    private String diseaseCode;
    private String syndrome;
    private Integer efficacyLevel;
    private String evidenceLevel;
    private String clinicalData;
    private Timestamp createdAt;
} 