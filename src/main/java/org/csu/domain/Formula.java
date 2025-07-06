package org.csu.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.sql.Timestamp;

@Data
@TableName("formula")
public class Formula {
    @TableId(type = IdType.AUTO)
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
    private Integer status;
    private Long createdBy;
    private Timestamp createdAt;
    private Timestamp updatedAt;
} 