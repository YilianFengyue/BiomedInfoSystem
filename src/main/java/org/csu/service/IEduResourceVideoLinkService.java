package org.csu.service;

import org.csu.domain.EduResourceVideoLink;
import com.baomidou.mybatisplus.extension.service.IService;
import org.csu.dto.VideoDto; // 确保引入视频DTO

import java.util.List;

/**
 * <p>
 * 资源与视频的关联表 服务类
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
public interface IEduResourceVideoLinkService extends IService<EduResourceVideoLink> {

    /**
     * 根据教学资源ID，查询其关联的所有视频的详细信息列表
     *
     * @param resourceId 教学资源ID
     * @return 关联的视频DTO列表
     */
    List<VideoDto> findVideosByResourceId(Long resourceId);

    /**
     * 根据视频ID，查询它被哪些教学资源所关联
     *
     * @param videoId 视频ID
     * @return 关联的教学资源ID列表
     */
    List<Long> findResourceIdsByVideoId(Long videoId);

    /**
     * 更新某个教学资源下视频的排序
     *
     * @param resourceId      教学资源ID
     * @param orderedVideoIds 包含已排好序的视频ID的列表
     */
    void updateVideoOrderForResource(Long resourceId, List<Long> orderedVideoIds);
}
