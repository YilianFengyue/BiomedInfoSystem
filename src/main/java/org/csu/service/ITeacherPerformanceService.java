package org.csu.service;

import org.csu.dto.TeacherScoreDto;

import java.util.List;

public interface ITeacherPerformanceService {
    /**
     * 计算指定教师的考核成绩
     * @param teacherId 教师ID
     * @return 教师的考核成绩
     */
    TeacherScoreDto calculateTeacherScore(Long teacherId);

    /**
     * 计算所有教师的考核成绩
     * @return 所有教师的考核成绩列表
     */
    List<TeacherScoreDto> calculateAllTeachersScores();
} 