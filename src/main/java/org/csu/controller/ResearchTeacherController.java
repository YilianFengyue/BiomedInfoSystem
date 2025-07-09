// ResearchTeacherController.java
package org.csu.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.csu.domain.research.*;
import org.csu.dto.*;
import org.csu.service.IResearchTeacherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/teacher/research")
public class ResearchTeacherController {

    @Autowired
    private IResearchTeacherService researchTeacherService;

    // ===== 课题管理 =====

    @PostMapping("/projects")
    public Result<Long> createProject(@RequestBody ProjectCreateDTO dto) {
        Long projectId = researchTeacherService.createProject(dto);
        return Result.success(projectId, "课题创建成功");
    }

    @GetMapping("/projects")
    public Result<Page<ProjectVO>> getMyProjects(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String projectType,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String researchField) {

        ProjectQueryDTO query = new ProjectQueryDTO();
        query.setKeyword(keyword);
        query.setProjectType(projectType);
        query.setStatus(status);
        query.setResearchField(researchField);

        Page<ProjectVO> result = researchTeacherService.getMyProjects(page, size, query);
        return Result.success(result);
    }

    @GetMapping("/projects/{id}")
    public Result<ProjectVO> getProjectDetail(@PathVariable Long id) {
        ProjectVO project = researchTeacherService.getProjectDetail(id);
        return Result.success(project);
    }

    @PutMapping("/projects/{id}")
    public Result<Void> updateProject(@PathVariable Long id, @RequestBody ProjectCreateDTO dto) {
        researchTeacherService.updateProject(id, dto);
        return Result.success(null, "课题更新成功");
    }

    @DeleteMapping("/projects/{id}")
    public Result<Void> deleteProject(@PathVariable Long id) {
        researchTeacherService.deleteProject(id);
        return Result.success(null, "课题删除成功");
    }

    // ===== 申请审核 =====
    //2.1 获取待审核申请列表
    @GetMapping("/applications")
    public Result<Page<ProjectApplication>> getPendingApplications(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) Long projectId) {

        Page<ProjectApplication> result = researchTeacherService.getPendingApplications(page, size, projectId);
        return Result.success(result);
    }
    //2.2 审核申请（同意）
    @PostMapping("/applications/review")
    public Result<Void> reviewApplication(@RequestBody ApplicationReviewDTO dto) {
        researchTeacherService.reviewApplication(dto);
        return Result.success(null, "申请审核完成");
    }
    //2.3 审核申请（拒绝）
    @GetMapping("/projects/{projectId}/applications")
    public Result<List<ProjectApplication>> getProjectApplications(@PathVariable Long projectId) {
        List<ProjectApplication> applications = researchTeacherService.getProjectApplications(projectId);
        return Result.success(applications);
    }

    // ===== 任务管理 =====

    @PostMapping("/tasks")
    public Result<Long> createTask(@RequestBody TaskCreateDTO dto) {
        Long taskId = researchTeacherService.createTask(dto);
        return Result.success(taskId, "任务创建成功");
    }

    @GetMapping("/tasks")
    public Result<Page<TaskVO>> getMyTasks(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) Long projectId) {

        Page<TaskVO> result = researchTeacherService.getMyTasks(page, size, projectId);
        return Result.success(result);
    }

    @PutMapping("/tasks/{id}")
    public Result<Void> updateTask(@PathVariable Long id, @RequestBody TaskCreateDTO dto) {
        researchTeacherService.updateTask(id, dto);
        return Result.success(null, "任务更新成功");
    }

    @DeleteMapping("/tasks/{id}")
    public Result<Void> deleteTask(@PathVariable Long id) {
        researchTeacherService.deleteTask(id);
        return Result.success(null, "任务删除成功");
    }

    @GetMapping("/tasks/{id}/submissions")
    public Result<List<PaperSubmissionVO>> getTaskSubmissions(@PathVariable Long id) {
        List<PaperSubmissionVO> submissions = researchTeacherService.getTaskSubmissions(id);
        return Result.success(submissions);
    }

    // ===== 论文评审 =====

    @GetMapping("/submissions/pending")
    public Result<Page<PaperSubmissionVO>> getPendingReviews(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {

        Page<PaperSubmissionVO> result = researchTeacherService.getPendingReviews(page, size);
        return Result.success(result);
    }

    @GetMapping("/submissions/{id}")
    public Result<PaperSubmission> getSubmissionDetail(@PathVariable Long id) {
        PaperSubmission submission = researchTeacherService.getSubmissionDetail(id);
        return Result.success(submission);
    }

    @PostMapping("/reviews")
    public Result<Long> submitReview(@RequestBody ReviewCreateDTO dto) {
        Long reviewId = researchTeacherService.submitReview(dto);
        return Result.success(reviewId, "评审提交成功");
    }

    @PutMapping("/reviews/{id}")
    public Result<Void> updateReview(@PathVariable Long id, @RequestBody ReviewCreateDTO dto) {
        researchTeacherService.updateReview(id, dto);
        return Result.success(null, "评审更新成功");
    }
}

