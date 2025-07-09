package org.csu.domain.research;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
/**
 * <p>
 * 论文提交表
 * </p>
 *
 * @author YinBo
 * @since 2025-07-08
 */
@Getter
@Setter
@ToString
@TableName("res_paper_submission")
public class PaperSubmission implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 任务ID
     */
    private Long taskId;

    /**
     * 学生ID
     */
    private Long studentId;

    /**
     * 论文标题
     */
    private String title;

    /**
     * 论文摘要
     */
    @TableField("abstract")
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
     * 原始文件名
     */
    private String fileName;

    /**
     * 文件大小(字节)
     */
    private Long fileSize;

    /**
     * 版本号
     */
    private Integer version;

    /**
     * 提交说明
     */
    private String submissionNotes;

    /**
     * 状态：submitted/reviewing/approved/needs_revision/rejected
     */
    private String status;

    private LocalDateTime submissionTime;
}
