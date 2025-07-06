package org.csu.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.sql.Timestamp;

@Data
@TableName("formula_herb")
public class FormulaHerb {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long formulaId;
    private Long herbId;
    private String herbName;
    private String dosage;
    private String unit;
    private String role;
    private String processing;
    private String usageNote;
    private Integer sortOrder;
    private Timestamp createdAt;
} 