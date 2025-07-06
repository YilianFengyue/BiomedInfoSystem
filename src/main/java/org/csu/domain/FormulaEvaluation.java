package org.csu.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

@Data
@TableName("formula_evaluation")
public class FormulaEvaluation {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long formulaId;
    private Long evaluatorId;
    private String evaluationType;
    private BigDecimal score;
    private String evaluationContent;
    private String evidenceFiles;
    private Date evaluationDate;
    private String status;
    private Timestamp createdAt;
} 