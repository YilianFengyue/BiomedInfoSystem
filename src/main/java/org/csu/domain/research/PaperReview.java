package org.csu.domain.research;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
/**
 * <p>
 * 论文评审表
 * </p>
 *
 * @author YinBo
 * @since 2025-07-08
 */
@Getter
@Setter
@ToString
@TableName("res_paper_review")
public class PaperReview implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 提交记录ID
     */
    private Long submissionId;

    /**
     * 评审人ID
     */
    private Long reviewerId;

    /**
     * 总体评分(1-10)
     */
    private BigDecimal overallScore;

    /**
     * 内容质量评分
     */
    private BigDecimal contentScore;

    /**
     * 创新性评分
     */
    private BigDecimal innovationScore;

    /**
     * 方法学评分
     */
    private BigDecimal methodologyScore;

    /**
     * 写作质量评分
     */
    private BigDecimal writingScore;

    /**
     * 评审意见
     */
    private String reviewComment;

    /**
     * 修改建议
     */
    private String suggestions;

    /**
     * 评审结果：accept/minor_revision/major_revision/reject
     */
    private String reviewResult;

    private LocalDateTime reviewTime;

    /**
     * 是否为最终评审
     */
    private Boolean isFinal;
}
