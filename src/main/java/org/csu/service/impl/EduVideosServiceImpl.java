// src/main/java/org/csu/service/impl/EduVideosServiceImpl.java

package org.csu.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.csu.config.BusinessException;
import org.csu.controller.Code;
import org.csu.dao.EduVideosDao;
import org.csu.domain.EduVideos;
<<<<<<< HEAD
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
import org.springframework.util.CollectionUtils; // 【新增】导入 CollectionUtils

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
    public org.springframework.data.domain.Page<VideoDto> findPaginated(Pageable pageable) {
        // 1. 将Spring Data的Pageable转换为MyBatis-Plus的Page
        Page<EduVideos> mpPage = new Page<>(pageable.getPageNumber() + 1, pageable.getPageSize());

        // 2. 执行基础分页查询
        this.page(mpPage, null);

        List<EduVideos> videoRecords = mpPage.getRecords();
        // 如果查询结果为空，直接返回一个空的Spring Page对象
        if (CollectionUtils.isEmpty(videoRecords)) {
            return new PageImpl<>(Collections.emptyList(), pageable, 0);
        }

        // 3. 【新增逻辑】从视频记录中提取所有 uploaderId
        List<Long> uploaderIds = videoRecords.stream()
                .map(EduVideos::getUploaderId)
                .distinct() // 去重，减少数据库查询压力
                .collect(Collectors.toList());

        // 4. 【新增逻辑】根据 uploaderIds 批量查询用户资料
        Map<Long, UserProfiles> userProfilesMap = userProfilesService.listByIds(uploaderIds).stream()
                .collect(Collectors.toMap(UserProfiles::getUserId, Function.identity()));

        // 5. 将查询到的实体列表 List<EduVideos> 转换为 DTO列表 List<VideoDto>
        List<VideoDto> dtoList = videoRecords.stream().map(entity -> {
            VideoDto dto = new VideoDto();
            BeanUtils.copyProperties(entity, dto);

            // 6. 【新增逻辑】从Map中查找并设置上传者姓名
            UserProfiles profile = userProfilesMap.get(entity.getUploaderId());
            if (profile != null) {
                dto.setUploaderName(profile.getNickname()); // 使用昵称作为上传者姓名
            } else {
                dto.setUploaderName("未知上传者"); // 如果找不到，提供一个默认值
            }
            return dto;
        }).collect(Collectors.toList());

        // 7. 使用最终的DTO列表和MP分页结果的总数，创建并返回Spring Data的Page对象
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
}

