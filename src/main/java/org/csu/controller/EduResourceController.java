package org.csu.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.csu.dto.*;
import org.csu.service.IEduResourceVideoLinkService;
import org.csu.service.IEduResourcesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/resources")
@Tag(name = "教学资源管理", description = "核心模块，管理试验课程、课题研究等图文资源")
public class EduResourceController {

    @Autowired
    private IEduResourcesService resourceService;

    @Autowired
    private IEduResourceVideoLinkService resourceVideoLinkService;

    @GetMapping
    @Operation(summary = "分页查询教学资源列表", description = "可根据分类ID和标题进行筛选")
    public Result<Page<ResourceListDto>> getResources(
            @Parameter(description = "分类ID") @RequestParam(required = false) Integer categoryId,
            @Parameter(description = "标题关键字") @RequestParam(required = false) String title,
            @PageableDefault(sort = "createdAt", direction = Sort.Direction.DESC) Pageable pageable
    ) {

        // 返回分页后的数据，确保前端可以正确显示列表
        return Result.success(resourceService.findPaginated(categoryId, title, pageable));

    }

    @GetMapping("/{id}")
    @Operation(summary = "获取单个教学资源的详细信息")
    public Result<ResourceDetailDto> getResourceById(@PathVariable Long id) {
        return Result.success(resourceService.findById(id));
    }


    /*@PostMapping
    @Operation(summary = "创建一篇新的教学资源")
    public Result<ResourceDetailDto> createResource(@Valid @RequestBody ResourceCreateDto createDTO) {
        // 在Service层，会从SecurityContextHolder获取当前登录用户ID作为author_id
        ResourceDetailDto createdResource = resourceService.create(createDTO);
        return Result.success(createdResource);
    }*/


    @PutMapping("/{id}")
    @Operation(summary = "更新一篇教学资源")
    public Result<ResourceDetailDto> updateResource(@PathVariable Long id, @Valid @RequestBody ResourceUpdateDto updateDTO) {
        ResourceDetailDto updatedResource = resourceService.update(id, updateDTO);
        return Result.success(updatedResource);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除一篇教学资源")
    public Result<Void> deleteResource(@PathVariable Long id) {
        resourceService.delete(id);
        return Result.success();
    }

    // --- 资源与视频关联的接口 ---

    @PostMapping("/{resourceId}/videos")
    @Operation(summary = "为一个资源关联一个视频", description = "将视频库中的视频添加为课程章节")
    public Result<Void> linkVideoToResource(
            @PathVariable Long resourceId,
            @Valid @RequestBody LinkVideoDto linkVideoDTO
    ) {
        resourceService.linkVideo(resourceId, linkVideoDTO);
        return Result.success();
    }

    @DeleteMapping("/{resourceId}/videos/{videoId}")
    @Operation(summary = "为一个资源解除关联一个视频")
    public Result<Void> unlinkVideoFromResource(
            @PathVariable Long resourceId,
            @PathVariable Long videoId
    ) {
        resourceService.unlinkVideo(resourceId, videoId);
        return Result.success();
    }

    @GetMapping("/{resourceId}/videos")
    @Operation(summary = "获取资源下的所有视频列表")
    public Result<List<VideoDto>> getVideosForResource(@PathVariable Long resourceId) {
        List<VideoDto> videos = resourceVideoLinkService.findVideosByResourceId(resourceId);
        return Result.success(videos);
    }


    @PutMapping("/{resourceId}/videos/order")
    @Operation(summary = "更新资源下视频的排序")
    public Result<Void> updateVideoOrder(@PathVariable Long resourceId, @RequestBody List<Long> orderedVideoIds) {
        resourceVideoLinkService.updateVideoOrderForResource(resourceId, orderedVideoIds);
        return Result.success();
    }
}
