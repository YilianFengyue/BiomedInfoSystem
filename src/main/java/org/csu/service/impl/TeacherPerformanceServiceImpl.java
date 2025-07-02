package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.csu.dao.EduResourcesDao;
import org.csu.dao.EduVideosDao;
import org.csu.dao.UsersDao;
import org.csu.dao.VideoLikesDao;
import org.csu.domain.EduResources;
import org.csu.domain.EduVideos;
import org.csu.domain.Users;
import org.csu.dto.TeacherScoreDto;
import org.csu.service.ITeacherPerformanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class TeacherPerformanceServiceImpl implements ITeacherPerformanceService {

    @Autowired
    private UsersDao usersDao;

    @Autowired
    private EduVideosDao eduVideosDao;

    @Autowired
    private VideoLikesDao videoLikesDao;

    @Autowired
    private EduResourcesDao eduResourcesDao;

    @Override
    public TeacherScoreDto calculateTeacherScore(Long teacherId) {
        Users teacher = usersDao.selectById(teacherId);
        if (teacher == null || teacher.getRole() != 2) {
            return null; // Or throw an exception
        }
        
        List<TeacherScoreDto> allScores = calculateAllTeachersScores();
        return allScores.stream()
                .filter(scoreDto -> scoreDto.getTeacherId().equals(teacherId))
                .findFirst()
                .orElse(null);
    }

    @Override
    public List<TeacherScoreDto> calculateAllTeachersScores() {
        QueryWrapper<Users> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("role", 2);
        List<Users> teachers = usersDao.selectList(queryWrapper);

        if (teachers.isEmpty()) {
            return Collections.emptyList();
        }

        List<TeacherScoreDto> teacherScores = new ArrayList<>();
        for (Users teacher : teachers) {
            TeacherScoreDto dto = new TeacherScoreDto();
            dto.setTeacherId(teacher.getId());
            dto.setTeacherName(teacher.getUsername());

            List<EduVideos> videos = eduVideosDao.selectList(new QueryWrapper<EduVideos>().eq("uploader_id", teacher.getId()));
            if (videos.isEmpty()) {
                dto.setTotalLikes(0);
                dto.setTotalVideoDuration(0L);
            } else {
                List<Long> videoIds = videos.stream().map(EduVideos::getId).collect(Collectors.toList());
                Integer totalLikes = videoLikesDao.countByVideoIds(videoIds);
                dto.setTotalLikes(totalLikes);

                long totalDuration = videos.stream().mapToLong(EduVideos::getDuration).sum();
                dto.setTotalVideoDuration(totalDuration);
            }
            
            Long resourceCount = eduResourcesDao.selectCount(new QueryWrapper<EduResources>().eq("author_id", teacher.getId()));
            dto.setTotalResources(resourceCount);

            teacherScores.add(dto);
        }

        // Find max values for normalization
        int maxLikes = teacherScores.stream().mapToInt(TeacherScoreDto::getTotalLikes).max().orElse(1);
        long maxDuration = teacherScores.stream().mapToLong(TeacherScoreDto::getTotalVideoDuration).max().orElse(1L);
        long maxResources = teacherScores.stream().mapToLong(TeacherScoreDto::getTotalResources).max().orElse(1L);
        
        if (maxLikes == 0) maxLikes = 1;
        if (maxDuration == 0) maxDuration = 1L;
        if (maxResources == 0) maxResources = 1L;


        // Calculate final scores
        for (TeacherScoreDto dto : teacherScores) {
            double score = 0;
            score += ((double) dto.getTotalLikes() / maxLikes) * 40;
            score += ((double) dto.getTotalVideoDuration() / maxDuration) * 30;
            score += ((double) dto.getTotalResources() / maxResources) * 30;
            dto.setScore(score);
        }

        return teacherScores;
    }
} 