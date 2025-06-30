package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.csu.dao.EduResourceVideoLinkDao;
import org.csu.domain.EduResourceVideoLink;
import org.csu.domain.EduVideos;
import org.csu.dto.VideoDto;
import org.csu.service.IEduResourceVideoLinkService;
import org.csu.service.IEduVideosService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class EduResourceVideoLinkServiceImpl extends ServiceImpl<EduResourceVideoLinkDao, EduResourceVideoLink> implements IEduResourceVideoLinkService {

    @Autowired
    private IEduVideosService videosService; // 注入视频服务，用于查询视频详情

    /**
     * 根据教学资源ID，查询其关联的所有视频的详细信息列表
     * <p>
     * 这是最有用的一个方法，例如用于展示某个课程的所有视频章节。
     *
     * @param resourceId 教学资源ID
     * @return 关联的视频DTO列表
     */
    public List<VideoDto> findVideosByResourceId(Long resourceId) {
        // 1. 根据 resourceId 查询所有关联记录
        LambdaQueryWrapper<EduResourceVideoLink> queryWrapper = new LambdaQueryWrapper<>();
        // 建议：如果有关联表的排序字段（如 sort_order），在这里添加排序
        // queryWrapper.orderByAsc(EduResourceVideoLink::getSortOrder);
        queryWrapper.eq(EduResourceVideoLink::getResourceId, resourceId);
        List<EduResourceVideoLink> links = this.list(queryWrapper);

        if (links.isEmpty()) {
            return Collections.emptyList(); // 返回空列表，而不是null
        }

        // 2. 提取所有视频ID
        List<Long> videoIds = links.stream()
                .map(EduResourceVideoLink::getVideoId)
                .collect(Collectors.toList());

        // 3. 根据视频ID列表，批量查询视频的详细信息
        List<EduVideos> videoEntities = videosService.listByIds(videoIds);

        // 4. 将视频实体列表转换为DTO列表并返回
        return videoEntities.stream().map(entity -> {
            VideoDto dto = new VideoDto();
            BeanUtils.copyProperties(entity, dto);
            return dto;
        }).collect(Collectors.toList());
    }

    /**
     * 根据视频ID，查询它被哪些教学资源所关联
     * <p>
     * 这个方法不常用，但可用于“查看此视频被哪些课程使用”的功能。
     *
     * @param videoId 视频ID
     * @return 关联的教学资源ID列表
     */
    public List<Long> findResourceIdsByVideoId(Long videoId) {
        LambdaQueryWrapper<EduResourceVideoLink> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(EduResourceVideoLink::getVideoId, videoId);
        queryWrapper.select(EduResourceVideoLink::getResourceId); // 只查询resource_id字段，提高效率

        List<EduResourceVideoLink> links = this.list(queryWrapper);

        return links.stream()
                .map(EduResourceVideoLink::getResourceId)
                .collect(Collectors.toList());
    }

    /**
     * 更新某个教学资源下视频的排序
     * <p>
     * 这是一个很有用的高级功能，允许用户拖拽调整视频顺序。
     * 前提：您的 edu_resource_video_link 表中需要有一个 sort_order 字段。
     *
     * @param resourceId      教学资源ID
     * @param orderedVideoIds 包含已排好序的视频ID的列表
     */
    @Transactional // 这是一个写操作，建议加上事务
    public void updateVideoOrderForResource(Long resourceId, List<Long> orderedVideoIds) {
        // 1. 先删除该资源下的所有旧的关联关系
        LambdaQueryWrapper<EduResourceVideoLink> deleteWrapper = new LambdaQueryWrapper<>();
        deleteWrapper.eq(EduResourceVideoLink::getResourceId, resourceId);
        this.remove(deleteWrapper);

        // 2. 重新批量插入新的、带顺序的关联关系
        if (orderedVideoIds != null && !orderedVideoIds.isEmpty()) {
            List<EduResourceVideoLink> newLinks = new java.util.ArrayList<>();
            for (int i = 0; i < orderedVideoIds.size(); i++) {
                EduResourceVideoLink newLink = new EduResourceVideoLink();
                newLink.setResourceId(resourceId);
                newLink.setVideoId(orderedVideoIds.get(i));
                // newLink.setSortOrder(i + 1); // 设置新的顺序
                newLinks.add(newLink);
            }
            this.saveBatch(newLinks); // 批量插入
        }
    }
}
