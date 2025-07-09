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
 * 科研进度记录表
 * </p>
 *
 * @author YinBo
 * @since 2025-07-08
 */
@Getter
@Setter
@ToString
@TableName("res_progress_log")
public class ProgressLog implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 任务ID
     */
    private Long taskId;

    /**
     * 操作人ID
     */
    private Long userId;

    /**
     * 进度类型：task_created/task_assigned/paper_submitted/review_completed等
     */
    private String progressType;

    /**
     * 进度内容描述
     */
    private String progressContent;

    /**
     * 附件信息
     */
    private String attachments;

    private LocalDateTime createdAt;
}
