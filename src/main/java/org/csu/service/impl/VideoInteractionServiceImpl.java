package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.csu.dao.UserProfilesDao;
import org.csu.dao.VideoCommentsDao;
import org.csu.dao.VideoLikesDao;
import org.csu.domain.UserProfiles;
import org.csu.domain.VideoComment;
import org.csu.domain.VideoLike;
import org.csu.dto.CommentCreateDto;
import org.csu.dto.CommentDto;
import org.csu.dto.LikeDto;
import org.csu.service.IVideoInteractionService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class VideoInteractionServiceImpl implements IVideoInteractionService {

    @Autowired
    private VideoLikesDao videoLikesDao;

    @Autowired
    private VideoCommentsDao videoCommentsDao;

    @Autowired
    private UserProfilesDao userProfilesDao;

    @Override
    public LikeDto getLikeInfo(Long videoId, Long userId) {
        LambdaQueryWrapper<VideoLike> countWrapper = new LambdaQueryWrapper<>();
        countWrapper.eq(VideoLike::getVideoId, videoId);
        long count = videoLikesDao.selectCount(countWrapper);

        boolean isLiked = false;
        if (userId != null) {
            LambdaQueryWrapper<VideoLike> likeWrapper = new LambdaQueryWrapper<>();
            likeWrapper.eq(VideoLike::getVideoId, videoId).eq(VideoLike::getUserId, userId);
            isLiked = videoLikesDao.exists(likeWrapper);
        }
        return new LikeDto(count, isLiked);
    }

    @Override
    @Transactional
    public LikeDto toggleLike(Long videoId, Long userId) {
        LambdaQueryWrapper<VideoLike> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(VideoLike::getVideoId, videoId).eq(VideoLike::getUserId, userId);
        VideoLike existingLike = videoLikesDao.selectOne(wrapper);

        if (existingLike != null) {
            videoLikesDao.deleteById(existingLike.getId());
        } else {
            VideoLike newLike = new VideoLike();
            newLike.setVideoId(videoId);
            newLike.setUserId(userId);
            videoLikesDao.insert(newLike);
        }

        // 【关键修改】操作完成后，重新查询并返回最新的点赞信息
        return getLikeInfo(videoId, userId);
    }

    @Override
    public List<CommentDto> getComments(Long videoId) {
        LambdaQueryWrapper<VideoComment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(VideoComment::getVideoId, videoId).orderByDesc(VideoComment::getCreatedAt);
        List<VideoComment> comments = videoCommentsDao.selectList(wrapper);

        if (comments.isEmpty()) {
            return Collections.emptyList();
        }

        List<Long> userIds = comments.stream().map(VideoComment::getUserId).distinct().collect(Collectors.toList());
        List<UserProfiles> profiles = userProfilesDao.selectBatchIds(userIds);
        Map<Long, UserProfiles> profileMap = profiles.stream().collect(Collectors.toMap(UserProfiles::getUserId, p -> p));

        return comments.stream().map(comment -> {
            CommentDto dto = new CommentDto();
            BeanUtils.copyProperties(comment, dto);
            UserProfiles profile = profileMap.get(comment.getUserId());
            if (profile != null) {
                dto.setAuthorName(profile.getNickname());
                dto.setAvatarUrl(profile.getAvatarUrl());
            } else {
                dto.setAuthorName("匿名用户");
            }
            return dto;
        }).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public CommentDto postComment(Long videoId, CommentCreateDto commentCreateDto) {
        VideoComment comment = new VideoComment();
        comment.setVideoId(videoId);
        comment.setUserId(commentCreateDto.getUserId());
        comment.setContent(commentCreateDto.getContent());
        comment.setParentId(commentCreateDto.getParentId());

        // 1. 插入数据库，此时 comment 对象会由 MyBatis-Plus 自动填充ID
        videoCommentsDao.insert(comment);

        // 【关键修改】根据ID从数据库重新查询完整的、包含时间戳的留言对象
        VideoComment freshComment = videoCommentsDao.selectById(comment.getId());

        // 2. 查询作者信息
        UserProfiles profile = userProfilesDao.selectById(freshComment.getUserId());

        // 3. 构建DTO并返回
        CommentDto dto = new CommentDto();
        BeanUtils.copyProperties(freshComment, dto); // 使用从数据库获取的 freshComment
        if (profile != null) {
            dto.setAuthorName(profile.getNickname());
            dto.setAvatarUrl(profile.getAvatarUrl());
        }
        return dto;
    }
}