package org.csu.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
/**
 * <p>
 * 资源与视频的关联表
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Getter
@Setter
@ToString
@TableName("edu_resource_video_link")
public class EduResourceVideoLink implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 关联主键ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 外键：教学资源ID
     */
    private Long resourceId;

    /**
     * 外键：教学视频ID
     */
    private Long videoId;

    /**
     * 显示顺序 (用于课程章节排序)
     */
    private Integer displayOrder;
}
