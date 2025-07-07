package org.csu.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

@Data
@TableName("research_achievement")
public class ResearchAchievement {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long projectId;
    private String achievementType;
    private String title;
    private String authors;
    private String publication;
    private Date publishDate;
    private BigDecimal impactFactor;
    private Integer citationCount;
    private String doi;
    private String abstractText; // 'abstract' is a Java keyword
    private String keywords;
    private String fileUrl;
    private String status;
    private Long createdBy;
    private Timestamp createdAt;
} 