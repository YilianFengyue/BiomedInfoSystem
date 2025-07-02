package org.csu.controller;

import org.csu.dto.TeacherScoreDto;
import org.csu.service.ITeacherPerformanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/teachers")
public class TeacherPerformanceController {

    @Autowired
    private ITeacherPerformanceService teacherPerformanceService;

    @GetMapping("/scores")
    public Result<List<TeacherScoreDto>> getAllTeachersScores() {
        List<TeacherScoreDto> scores = teacherPerformanceService.calculateAllTeachersScores();
        return new Result<>(Code.GET_OK, scores, "成功获取所有教师的考核成绩");
    }

    @GetMapping("/{id}/score")
    public Result<TeacherScoreDto> getTeacherScore(@PathVariable Long id) {
        TeacherScoreDto score = teacherPerformanceService.calculateTeacherScore(id);
        if (score != null) {
            return new Result<>(Code.GET_OK, score, "成功获取教师的考核成绩");
        } else {
            return new Result<>(Code.GET_ERR, null, "未找到指定ID的教师或该用户不是教师");
        }
    }
} 