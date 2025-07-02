// src/main/java/org/csu/service/IVideoInteractionService.java
package org.csu.service;

import org.csu.dto.CommentCreateDto;
import org.csu.dto.CommentDto;
import org.csu.dto.LikeDto;

import java.util.List;

public interface IVideoInteractionService {
    LikeDto getLikeInfo(Long videoId, Long userId);

    // 返回值从 void 修改为 LikeDto，这将返回最新的点赞总数和用户的点赞状态
    LikeDto toggleLike(Long videoId, Long userId);

    List<CommentDto> getComments(Long videoId);
    CommentDto postComment(Long videoId, CommentCreateDto commentCreateDto);
}