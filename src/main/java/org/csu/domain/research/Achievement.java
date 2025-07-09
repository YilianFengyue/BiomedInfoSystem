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
 * 科研成果表(论文、专利等)
 * </p>
 *
 * @author YinBo
 * @since 2025-07-08
 */
@Getter
@Setter
@ToString
@TableName("res_achievement")
public class Achievement implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 关联项目ID
     */
    private Long projectId;

    /**
     * 成果类型
     */
    private String achievementType;

    /**
     * 成果标题
     */
    private String title;

    /**
     * 作者
     */
    private String authors;

    /**
     * 发表期刊/出版社
     */
    private String publication;

    /**
     * 发表日期
     */
    private LocalDate publishDate;

    /**
     * 影响因子
     */
    private BigDecimal impactFactor;

    /**
     * 引用次数
     */
    private Integer citationCount;

    /**
     * DOI
     */
    private String doi;

    /**
     * 摘要
     */
    private String abstractText;

    /**
     * 关键词
     */
    private String keywords;

    /**
     * 文件地址
     */
    private String fileUrl;

    /**
     * 状态
     */
    private String status;

    /**
     * 创建人
     */
    private Long createdBy;

    private LocalDateTime createdAt;
}
