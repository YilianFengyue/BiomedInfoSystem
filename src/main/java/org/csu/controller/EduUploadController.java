// 文件路径: src/main/java/org/csu/controller/EduUploadController.java
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

            // 【关键修改】强制将新上传的图文资源状态设置为 'draft'
            resource.setStatus("draft");
            // 草稿状态下，发布时间应为null
            resource.setPublishedAt(null);

            resourcesService.save(resource);
            return Result.success(resource);

        } else if ("video".equalsIgnoreCase(uploadDto.getResourceType())) {
            // 处理视频资源
            EduVideos video = new EduVideos();
            BeanUtils.copyProperties(uploadDto, video);

            video.setCoverUrl(uploadDto.getCoverImageUrl());
            video.setDescription(uploadDto.getDescription());
            video.setUploaderId(uploadDto.getAuthorId());
            video.setCreatedAt(LocalDateTime.now());

            // 强制将新上传的视频状态设置为 'draft'
            video.setStatus("draft");

            videosService.save(video);
            return Result.success(video);

        } else {
            return Result.error(Code.VALIDATE_ERR, "无效的资源类型");
        }
    }
}
