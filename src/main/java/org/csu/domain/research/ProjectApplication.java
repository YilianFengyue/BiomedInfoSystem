package org.csu.domain.research;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
/**
 * <p>
 * 科研课题申请表
 * </p>
 *
 * @author YinBo
 * @since 2025-07-08
 */
@Getter
@Setter
@ToString
@TableName("res_project_application")
public class ProjectApplication implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 课题ID
     */
    private Long projectId;

    /**
     * 学生ID
     */
    private Long studentId;

    /**
     * 申请理由
     */
    private String applicationReason;

    /**
     * 状态：pending/approved/rejected
     */
    private String status;

    /**
     * 审核人ID
     */
    private Long reviewedBy;

    /**
     * 审核时间
     */
    private LocalDateTime reviewedAt;

    /**
     * 审核意见
     */
    private String reviewComment;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
