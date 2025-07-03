// src/main/java/org/csu/service/impl/EduVideosServiceImpl.java

package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.csu.config.BusinessException;
import org.csu.controller.Code;
import org.csu.dao.EduVideosDao;
import org.csu.domain.EduVideos;

import org.csu.dto.VideoDto;
import org.csu.service.IEduVideosService;
import org.springframework.beans.BeanUtils;
import org.csu.domain.UserProfiles; // 【新增】导入 UserProfiles 实体
import org.csu.dto.VideoDto;
import org.csu.service.IEduVideosService;
import org.csu.service.IUserProfilesService; // 【新增】导入 UserProfiles 服务
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired; // 【新增】确保 Autowired 已导入
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils; // 【新增】导入 CollectionUtils
import org.springframework.util.StringUtils;

import java.util.Collections; // 【新增】导入 Collections
import java.util.List;
import java.util.Map; // 【新增】导入 Map
import java.util.function.Function; // 【新增】导入 Function
import java.util.stream.Collectors;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 教学视频库服务实现类
 *
 * @author YourName
 */
@Service
public class EduVideosServiceImpl extends ServiceImpl<EduVideosDao, EduVideos> implements IEduVideosService {


    // 【新增】注入 UserProfilesService，用于查询作者信息
    @Autowired
    private IUserProfilesService userProfilesService;


    @Override
    public VideoDto create(VideoDto videoDTO) {
        EduVideos entity = new EduVideos();
        BeanUtils.copyProperties(videoDTO, entity);


        this.save(entity); // 保存后，entity对象会被填充ID

        BeanUtils.copyProperties(entity, videoDTO);
        return videoDTO;
    }


    /**
     * 【重点修改】重写分页查询逻辑，以包含上传者姓名
     */
    @Override
    public org.springframework.data.domain.Page<VideoDto> findPaginated(Pageable pageable, String status) {
        Page<EduVideos> mpPage = new Page<>(pageable.getPageNumber() + 1, pageable.getPageSize());

        // 【关键修改】创建查询条件并添加状态过滤
        LambdaQueryWrapper<EduVideos> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(StringUtils.hasText(status), EduVideos::getStatus, status);
        queryWrapper.orderByDesc(EduVideos::getCreatedAt); // 添加排序

        this.page(mpPage, queryWrapper); // 使用带条件的查询

        List<EduVideos> videoRecords = mpPage.getRecords();
        if (CollectionUtils.isEmpty(videoRecords)) {
            return new PageImpl<>(Collections.emptyList(), pageable, 0);
        }

        List<Long> uploaderIds = videoRecords.stream()
                .map(EduVideos::getUploaderId)
                .distinct()
                .collect(Collectors.toList());

        Map<Long, UserProfiles> userProfilesMap = userProfilesService.listByIds(uploaderIds).stream()
                .collect(Collectors.toMap(UserProfiles::getUserId, Function.identity()));

        List<VideoDto> dtoList = videoRecords.stream().map(entity -> {
            VideoDto dto = new VideoDto();
            BeanUtils.copyProperties(entity, dto);
            UserProfiles profile = userProfilesMap.get(entity.getUploaderId());
            if (profile != null) {
                dto.setUploaderName(profile.getNickname());
            } else {
                dto.setUploaderName("未知上传者");
            }
            return dto;
        }).collect(Collectors.toList());

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


    /**
     * 【新增方法的具体实现】
     * @param id 视频ID
     * @return 视频详情DTO
     */
    @Override
    public VideoDto findById(Long id) {
        // 1. 根据ID获取视频实体
        EduVideos entity = this.getById(id);
        if (entity == null) {
            // 如果视频不存在，抛出业务异常
            throw new BusinessException(Code.GET_ERR, "查询失败：未找到ID为 " + id + " 的视频记录");
        }

        // 2. 创建DTO并复制基础属性
        VideoDto dto = new VideoDto();
        BeanUtils.copyProperties(entity, dto);

        // 3. 查询并设置上传者姓名
        if (entity.getUploaderId() != null) {
            UserProfiles profile = userProfilesService.getById(entity.getUploaderId());
            if (profile != null && profile.getNickname() != null) {
                dto.setUploaderName(profile.getNickname());
            } else {
                dto.setUploaderName("未知上传者"); // 找不到关联的用户时，提供默认值
            }
        }

        // 4. 返回组装好的DTO
        return dto;
    }

    /**
     * 新增方法的实现
     */
    @Override
    @Transactional
    public void updateStatus(Long id, String status) {
        EduVideos existingVideo = this.getById(id);
        if (existingVideo == null) {
            throw new BusinessException(Code.UPDATE_ERR, "更新失败：视频不存在, ID: " + id);
        }
        existingVideo.setStatus(status);
        this.updateById(existingVideo);
    }
}

