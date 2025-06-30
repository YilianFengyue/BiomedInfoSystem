package org.csu.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

/**
 * 用于在教学资源详情中，展示已关联视频的简化信息（可理解为课程的章节列表）
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class VideoInfoDto {

    /**
     * 视频的ID (来自 edu_videos.id)
     */
    private Long videoId;

    /**
     * 视频的标题 (来自 edu_videos.title)
     */
    private String title;

    /**
     * 视频时长，单位：秒 (来自 edu_videos.duration)
     */
    private Integer duration;

    /**
     * 在当前教学资源中的显示顺序 (来自关联表 edu_resource_video_link.display_order)
     * 这是最重要的字段之一，用于前端排序。
     */
    private int displayOrder;

}