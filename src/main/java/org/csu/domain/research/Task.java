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
 * 研究任务表
 * </p>
 *
 * @author YinBo
 * @since 2025-07-08
 */
@Getter
@Setter
@ToString
@TableName("res_task")
public class Task implements Serializable {

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
     * 教师ID
     */
    private Long teacherId;

    /**
     * 任务标题
     */
    private String title;

    /**
     * 任务描述
     */
    private String description;

    /**
     * 任务要求
     */
    private String requirements;

    /**
     * 截止日期
     */
    private LocalDate deadline;

    /**
     * 优先级：low/medium/high
     */
    private String priority;

    /**
     * 状态：assigned/in_progress/submitted/completed
     */
    private String status;

    /**
     * 完成进度百分比
     */
    private BigDecimal progress;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
