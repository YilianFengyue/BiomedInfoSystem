package org.csu.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.csu.dto.PageDto;
import org.csu.dto.VideoDto;
import org.csu.service.IEduVideosService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/videos")
@Tag(name = "教学视频库管理", description = "用于管理上传到OSS的视频元数据")
public class EduVideoController {

    @Autowired
    private IEduVideosService videoService;

    // ... (create, update, delete methods remain the same) ...

    @PostMapping
    @Operation(summary = "新增视频记录", description = "视频上传成功后，调用此接口将视频信息存入数据库")
    public Result<VideoDto> createVideoMetadata(@RequestBody VideoDto videoDTO) {
        return Result.success(videoService.create(videoDTO));
    }

    @GetMapping("/page")
    @Operation(summary = "分页查询视频库列表")
    public Result<PageDto<VideoDto>> getVideos(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        Pageable pageable = PageRequest.of(pageNum - 1, pageSize);
        Page<VideoDto> videoPage = videoService.findPaginated(pageable);
        return Result.success(new PageDto<>(videoPage));
    }

    /**
     * 【新增的接口】
     * 根据ID获取单个视频的详细信息。
     * This method handles GET requests to /api/videos/{id}
     *
     * @param id The ID of the video, extracted from the path.
     * @return A Result object containing the detailed video DTO.
     */
    @GetMapping("/{id}")
    @Operation(summary = "获取单个视频详情")
    public Result<VideoDto> getVideoById(@PathVariable Long id) {
        // We assume you have already created the findById method in IEduVideosService and its implementation
        VideoDto videoDto = videoService.findById(id);
        return Result.success(videoDto);
    }

    @PutMapping("/{id}")
    @Operation(summary = "更新视频信息")
    public Result<VideoDto> updateVideoMetadata(@PathVariable Long id, @RequestBody VideoDto videoDTO) {
        return Result.success(videoService.update(id, videoDTO));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "从视频库删除视频记录")
    public Result<Void> deleteVideo(@PathVariable Long id) {
        videoService.delete(id);
        return Result.success();
    }
}