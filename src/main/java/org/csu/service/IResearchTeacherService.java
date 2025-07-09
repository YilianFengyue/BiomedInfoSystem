package org.csu.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.csu.domain.research.*;
import org.csu.dto.*;

import java.util.List;

public interface IResearchTeacherService {

    // 课题管理
    Long createProject(ProjectCreateDTO dto);
    Page<ProjectVO> getMyProjects(Integer page, Integer size, ProjectQueryDTO query);
    ProjectVO getProjectDetail(Long projectId);
    void updateProject(Long projectId, ProjectCreateDTO dto);
    void deleteProject(Long projectId);

    // 申请审核
    Page<ProjectApplication> getPendingApplications(Integer page, Integer size, Long projectId);
    void reviewApplication(ApplicationReviewDTO dto);
    List<ProjectApplication> getProjectApplications(Long projectId);

    // 任务管理
    Long createTask(TaskCreateDTO dto);
    Page<TaskVO> getMyTasks(Integer page, Integer size, Long projectId);
    void updateTask(Long taskId, TaskCreateDTO dto);
    void deleteTask(Long taskId);
    List<PaperSubmissionVO> getTaskSubmissions(Long taskId);

    // 论文评审
    Page<PaperSubmissionVO> getPendingReviews(Integer page, Integer size);
    PaperSubmission getSubmissionDetail(Long submissionId);
    Long submitReview(ReviewCreateDTO dto);
    void updateReview(Long reviewId, ReviewCreateDTO dto);
}
