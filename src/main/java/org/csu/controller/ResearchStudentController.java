// ResearchStudentController.java
package org.csu.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.csu.domain.research.*;
import org.csu.dto.*;
import org.csu.service.IResearchStudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/student/research")
public class ResearchStudentController {

    @Autowired
    private IResearchStudentService researchStudentService;

    // ===== 课题浏览与申请 =====

    @GetMapping("/projects/available")
    public Result<Page<ProjectVO>> getAvailableProjects(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String projectType,
            @RequestParam(required = false) String researchField) {

        ProjectQueryDTO query = new ProjectQueryDTO();
        query.setKeyword(keyword);
        query.setProjectType(projectType);
        query.setResearchField(researchField);

        Page<ProjectVO> result = researchStudentService.getAvailableProjects(page, size, query);
        return Result.success(result);
    }

    @GetMapping("/projects/{id}")
    public Result<ProjectVO> getProjectDetail(@PathVariable Long id) {
        ProjectVO project = researchStudentService.getProjectDetail(id);
        return Result.success(project);
    }

    @PostMapping("/applications")
    public Result<Long> applyForProject(
            @RequestParam Long projectId,
            @RequestParam String applicationReason) {

        Long applicationId = researchStudentService.applyForProject(projectId, applicationReason);
        return Result.success(applicationId, "申请提交成功");
    }

    @GetMapping("/applications")
    public Result<List<ProjectApplication>> getMyApplications() {
        List<ProjectApplication> applications = researchStudentService.getMyApplications();
        return Result.success(applications);
    }

    @DeleteMapping("/applications/{id}")
    public Result<Void> withdrawApplication(@PathVariable Long id) {
        researchStudentService.withdrawApplication(id);
        return Result.success(null, "申请已撤回");
    }

    // ===== 任务管理 =====

    @GetMapping("/tasks")
    public Result<Page<TaskVO>> getMyTasks(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {

        Page<TaskVO> result = researchStudentService.getMyTasks(page, size);
        return Result.success(result);
    }

    @GetMapping("/tasks/{id}")
    public Result<TaskVO> getTaskDetail(@PathVariable Long id) {
        TaskVO task = researchStudentService.getTaskDetail(id);
        return Result.success(task);
    }

    @PutMapping("/tasks/{id}/status")
    public Result<Void> updateTaskStatus(
            @PathVariable Long id,
            @RequestParam String status) {

        researchStudentService.updateTaskStatus(id, status);
        return Result.success(null, "任务状态更新成功");
    }

    @PostMapping("/tasks/{id}/progress")
    public Result<Void> updateTaskProgress(
            @PathVariable Long id,
            @RequestParam String progressContent) {

        researchStudentService.updateTaskProgress(id, progressContent);
        return Result.success(null, "进度更新成功");
    }

    // ===== 论文提交 =====

    @PostMapping("/submissions")
    public Result<Long> submitPaper(
            @RequestBody PaperSubmissionDTO dto) {
        Long submissionId = researchStudentService.submitPaper(dto);
        return Result.success(submissionId, "论文提交成功");
    }

    @GetMapping("/submissions")
    public Result<List<PaperSubmissionVO>> getMySubmissions() {
        List<PaperSubmissionVO> submissions = researchStudentService.getMySubmissions();
        return Result.success(submissions);
    }

    @PutMapping("/submissions/{id}")
    public Result<Void> updatePaperSubmission(
            @PathVariable Long id,
            @RequestBody PaperSubmissionDTO dto) {

        researchStudentService.updatePaperSubmission(id, dto);
        return Result.success(null, "论文更新成功");
    }

    @GetMapping("/submissions/{id}/reviews")
    public Result<List<PaperReview>> getSubmissionReviews(@PathVariable Long id) {
        List<PaperReview> reviews = researchStudentService.getSubmissionReviews(id);
        return Result.success(reviews);
    }

    // ===== 进度记录 =====

    @GetMapping("/tasks/{id}/progress")
    public Result<List<ProgressLog>> getTaskProgress(@PathVariable Long id) {
        List<ProgressLog> progress = researchStudentService.getTaskProgress(id);
        return Result.success(progress);
    }
}