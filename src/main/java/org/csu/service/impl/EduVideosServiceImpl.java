package org.csu.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.csu.config.BusinessException;
import org.csu.controller.Code;
import org.csu.dao.EduVideosDao;
import org.csu.domain.EduVideos;
import org.csu.dto.VideoDto;
import org.csu.service.IEduVideosService;
import org.springframework.beans.BeanUtils;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 教学视频库服务实现类
 *
 * @author YourName
 */
@Service
public class EduVideosServiceImpl extends ServiceImpl<EduVideosDao, EduVideos> implements IEduVideosService {

    @Override
    public VideoDto create(VideoDto videoDTO) {
        EduVideos entity = new EduVideos();
        BeanUtils.copyProperties(videoDTO, entity);


        this.save(entity); // 保存后，entity对象会被填充ID

        BeanUtils.copyProperties(entity, videoDTO);
        return videoDTO;
    }

    @Override
    public org.springframework.data.domain.Page<VideoDto> findPaginated(Pageable pageable) {
        // 1. 将Spring Data的Pageable转换为MyBatis-Plus的Page
        // 注意：Spring的页码从0开始，MP从1开始
        Page<EduVideos> mpPage = new Page<>(pageable.getPageNumber() + 1, pageable.getPageSize());

        // 2. 执行分页查询 (无条件查询所有)
        this.page(mpPage, null);

        // 3. 将查询到的实体列表 List<EduVideos> 转换为 DTO列表 List<VideoDto>
        List<VideoDto> dtoList = mpPage.getRecords().stream().map(entity -> {
            VideoDto dto = new VideoDto();
            BeanUtils.copyProperties(entity, dto);
            return dto;
        }).collect(Collectors.toList());

        // 4. 使用DTO列表和MP分页结果的总数，创建并返回Spring Data的Page对象
        return new PageImpl<>(dtoList, pageable, mpPage.getTotal());
    }

    @Override
    public VideoDto update(Long id, VideoDto videoDTO) {
        // 1. 检查要更新的记录是否存在
        EduVideos existingEntity = this.getById(id);
        if (existingEntity == null) {
            throw new BusinessException(Code.UPDATE_ERR, "更新失败：未找到ID为 " + id + " 的视频记录");
        }

        // 2. 将DTO的属性复制到查出的实体中
        BeanUtils.copyProperties(videoDTO, existingEntity);
        existingEntity.setId(id); // 确保ID不会被覆盖

        // 3. 执行更新
        this.updateById(existingEntity);

        // 4. 返回更新后的DTO
        BeanUtils.copyProperties(existingEntity, videoDTO);
        return videoDTO;
    }

    @Override
    public void delete(Long id) {
        // 1. 检查记录是否存在
        if (this.getById(id) == null) {
            throw new BusinessException(Code.DELETE_ERR, "删除失败：未找到ID为 " + id + " 的视频记录");
        }

        // 2. 执行删除
        this.removeById(id);
        // 注意：OSS上的物理文件可能需要额外逻辑来清理
    }
}
