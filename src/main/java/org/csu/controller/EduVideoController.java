package org.csu.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.csu.dto.*;
import org.csu.service.IEduVideosService;
import org.csu.service.IVideoInteractionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/videos")
@Tag(name = "教学视频库管理", description = "用于管理上传到OSS的视频元数据")
public class EduVideoController {

    @Autowired
    private IEduVideosService videoService;


    @Autowired
    private IVideoInteractionService videoInteractionService;



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

    @GetMapping("/{id}")
    @Operation(summary = "获取单个视频详情")
    public Result<VideoDto> getVideoById(@PathVariable Long id) {
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


    // --- 新增接口 ---

    @GetMapping("/{id}/likes")
    @Operation(summary = "获取视频的点赞信息")
    public Result<LikeDto> getLikeInfo(@PathVariable Long id, @RequestParam Long userId) {
        return Result.success(videoInteractionService.getLikeInfo(id, userId));
    }

    @PostMapping("/{id}/like")
    @Operation(summary = "点赞或取消点赞视频")
    public Result<LikeDto> toggleLike(@PathVariable Long id, @RequestBody Map<String, Long> payload) {
        // 【关键修改】调用修改后的service方法，并将其返回的最新状态作为成功响应的数据
        LikeDto newLikeState = videoInteractionService.toggleLike(id, payload.get("userId"));
        return Result.success(newLikeState, "操作成功");
    }

    @GetMapping("/{id}/comments")
    @Operation(summary = "获取视频的留言列表")
    public Result<List<CommentDto>> getComments(@PathVariable Long id) {
        return Result.success(videoInteractionService.getComments(id));
    }

    @PostMapping("/{id}/comments")
    @Operation(summary = "为视频发表留言")
    public Result<CommentDto> postComment(@PathVariable Long id, @Valid @RequestBody CommentCreateDto commentCreateDto) {
        return Result.success(videoInteractionService.postComment(id, commentCreateDto));
    }
}

