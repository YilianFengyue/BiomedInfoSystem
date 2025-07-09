package org.csu.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.csu.domain.research.*;
import org.csu.dto.*;

import java.util.List;

public interface IResearchStudentService {

    // 课题浏览与申请
    Page<ProjectVO> getAvailableProjects(Integer page, Integer size, ProjectQueryDTO query);
    ProjectVO getProjectDetail(Long projectId);
    Long applyForProject(Long projectId, String applicationReason);
    List<ProjectApplication> getMyApplications();
    void withdrawApplication(Long applicationId);

    // 任务管理
    Page<TaskVO> getMyTasks(Integer page, Integer size);
    TaskVO getTaskDetail(Long taskId);
    void updateTaskStatus(Long taskId, String status);
    void updateTaskProgress(Long taskId, String progressContent);

    // 论文提交
    Long submitPaper(PaperSubmissionDTO dto);
    List<PaperSubmissionVO> getMySubmissions();
    void updatePaperSubmission(Long submissionId, PaperSubmissionDTO dto);
    List<PaperReview> getSubmissionReviews(Long submissionId);

    // 进度记录
    List<ProgressLog> getTaskProgress(Long taskId);
}