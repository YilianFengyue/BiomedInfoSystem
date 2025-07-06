package org.csu.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.sql.Timestamp;

@Data
@TableName("formula_modification")
public class FormulaModification {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long baseFormulaId;
    private String modifiedName;
    private String modificationType;
    private String conditionDescription;
    private String herbChanges;
    private String effectChanges;
    private Long createdBy;
    private Timestamp createdAt;
} 