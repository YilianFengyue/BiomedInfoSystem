package org.csu.service;

import com.baomidou.mybatisplus.extension.service.IService;
import org.csu.domain.EduVideos;
import org.csu.dto.VideoDto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

/**
 * 教学视频库服务接口
 *
 * @author YourName
 */
public interface IEduVideosService extends IService<EduVideos> {

    /**
     * 新增视频元数据记录
     *
     * @param videoDTO 包含视频信息的DTO
     * @return 创建成功后的视频DTO（包含ID）
     */
    VideoDto create(VideoDto videoDTO);

    /**
     * 分页查询视频库列表
     *
     * @param pageable Spring Data的分页对象
     * @return 包含视频DTO的分页结果
     */
    Page<VideoDto> findPaginated(Pageable pageable);

    /**
     * 更新视频元数据
     *
     * @param id       要更新的视频ID
     * @param videoDTO 包含更新信息的DTO
     * @return 更新成功后的视频DTO
     */
    VideoDto update(Long id, VideoDto videoDTO);

    /**
     * 根据ID删除视频元数据
     *
     * @param id 要删除的视频ID
     */
    void delete(Long id);

    VideoDto findById(Long id);
}
