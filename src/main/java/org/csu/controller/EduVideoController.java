package org.csu.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.csu.dto.VideoDto;
import org.csu.service.IEduVideosService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/videos")
@Tag(name = "教学视频库管理", description = "用于管理上传到OSS的视频元数据")
public class EduVideoController {

    @Autowired
    private IEduVideosService videoService;



    // 注意：视频文件上传通常是一个独立的上传接口，这里只管理视频的元数据

    @PostMapping
    @Operation(summary = "新增视频记录", description = "视频上传成功后，调用此接口将视频信息存入数据库")
    public Result<VideoDto> createVideoMetadata(@RequestBody VideoDto videoDTO) {
        // uploader_id 应从当前登录用户获取
        return Result.success(videoService.create(videoDTO));
    }

    @GetMapping
    @Operation(summary = "分页查询视频库列表")
    public Result<Page<VideoDto>> getVideos(Pageable pageable) {
        return Result.success(videoService.findPaginated(pageable));
    }

    @PutMapping("/{id}")
    @Operation(summary = "更新视频信息")
    public Result<VideoDto> updateVideoMetadata(@PathVariable Long id, @RequestBody VideoDto videoDTO) {
        return Result.success(videoService.update(id, videoDTO));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "从视频库删除视频记录")
    public Result<Void> deleteVideo(@PathVariable Long id) {
        // 注意：这里通常只删除数据库记录，OSS上的物理文件可能需要异步任务去清理
        videoService.delete(id);
        return Result.success();
    }
}
