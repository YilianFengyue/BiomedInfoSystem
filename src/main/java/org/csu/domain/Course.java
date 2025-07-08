package org.csu.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

@Data
@TableName("course")
public class Course implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private String title;
    private String subtitle;
    private Integer categoryId;
    private Long teacherId;
    private String coverImage;
    private String introduction;
    private String objectives;
    private Integer difficultyLevel;
    private Integer duration;
    private BigDecimal price;
    private String status;
    private Integer viewCount;
    private Integer studentCount;
    private BigDecimal rating;
    private String tags;
    private Timestamp createdAt;
    private Timestamp updatedAt;
}