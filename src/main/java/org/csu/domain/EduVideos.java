package org.csu.domain;

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
 * 教学视频库
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Getter
@Setter
@ToString
@TableName("edu_videos")
public class EduVideos implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 视频主键ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 视频标题
     */
    private String title;

    /**
     * 视频简介
     */
    private String description;

    /**
     * 视频文件URL (来自OSS)
     */
    private String videoUrl;

    /**
     * 视频封面URL (可选)
     */
    private String coverUrl;

    /**
     * 视频时长 (单位: 秒)
     */
    private Integer duration;

    /**
     * 外键：上传者的用户ID
     */
    private Long uploaderId;

    /**
     * 上传时间
     */
    private LocalDateTime createdAt;
}
