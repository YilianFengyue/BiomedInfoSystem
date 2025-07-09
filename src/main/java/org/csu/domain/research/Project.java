package org.csu.domain.research;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
/**
 * <p>
 * 科研项目表
 * </p>
 *
 * @author YinBo
 * @since 2025-07-08
 */
@Getter
@Setter
@ToString
@TableName("res_project")
public class Project implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 项目名称
     */
    private String projectName;

    /**
     * 项目编号
     */
    private String projectCode;

    /**
     * 项目类型
     */
    private String projectType;

    /**
     * 资助来源
     */
    private String fundingSource;

    /**
     * 资助金额
     */
    private BigDecimal fundingAmount;

    /**
     * 项目负责人ID
     */
    private Long principalInvestigator;

    /**
     * 开始日期
     */
    private LocalDate startDate;

    /**
     * 结束日期
     */
    private LocalDate endDate;

    /**
     * 状态
     */
    private String status;

    /**
     * 项目摘要
     */
    private String abstractText;

    /**
     * 关键词
     */
    private String keywords;

    /**
     * 研究领域
     */
    private String researchField;

    /**
     * 项目成果
     */
    private String achievements;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
