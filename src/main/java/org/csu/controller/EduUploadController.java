// src/main/java/org/csu/controller/EduUploadController.java
package org.csu.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.csu.domain.EduResources;
import org.csu.domain.EduVideos;
import org.csu.dto.ResourceUploadDto;
import org.csu.service.IEduResourcesService;
import org.csu.service.IEduVideosService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.CrossOrigin;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/edu")
@Tag(name = "统一资源上传", description = "处理图文和视频资源的统一上传入口")
@CrossOrigin(origins = "*") // 确保允许跨域
public class EduUploadController {

    @Autowired
    private IEduResourcesService resourcesService;

    @Autowired
    private IEduVideosService videosService;

    @PostMapping("/upload")
    @Operation(summary = "统一上传接口", description = "根据resourceType字段自动区分图文或视频资源")
    public Result<?> uploadResource(@Valid @RequestBody ResourceUploadDto uploadDto) {

        if ("text".equalsIgnoreCase(uploadDto.getResourceType())) {
            // 处理图文资源
            EduResources resource = new EduResources();
            BeanUtils.copyProperties(uploadDto, resource);
            resource.setCreatedAt(LocalDateTime.now());
            resource.setPublishedAt( "published".equals(uploadDto.getStatus()) ? LocalDateTime.now() : null);

            resourcesService.save(resource);
            return Result.success(resource);

        } else if ("video".equalsIgnoreCase(uploadDto.getResourceType())) {
            // 处理视频资源
            EduVideos video = new EduVideos();
            BeanUtils.copyProperties(uploadDto, video);

            // 【关键修正】手动将DTO中的coverImageUrl设置到video实体的coverUrl字段
            video.setCoverUrl(uploadDto.getCoverImageUrl());

            video.setDescription(uploadDto.getDescription());
            video.setUploaderId(uploadDto.getAuthorId());
            video.setCreatedAt(LocalDateTime.now());

            videosService.save(video);
            return Result.success(video);

        } else {
            return Result.error(Code.VALIDATE_ERR, "无效的资源类型");
        }
    }
}