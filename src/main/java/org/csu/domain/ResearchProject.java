package org.csu.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

@Data
@TableName("research_project")
public class ResearchProject {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String projectName;
    private String projectCode;
    private String projectType;
    private String fundingSource;
    private BigDecimal fundingAmount;
    private Long principalInvestigator;
    private Date startDate;
    private Date endDate;
    private String status;
    private String abstractText; // 'abstract' is a Java keyword
    private String keywords;
    private String researchField;
    private String achievements;
    private Timestamp createdAt;
    private Timestamp updatedAt;
} 