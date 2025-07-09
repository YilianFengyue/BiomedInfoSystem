// ResearchStudentServiceImpl.java
package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.csu.config.BusinessException;
import org.csu.controller.Code;
import org.csu.dao.research.*;
import org.csu.domain.research.*;
import org.csu.dto.*;
import org.csu.service.IResearchStudentService;
import org.csu.util.AuthenticationHelperUtil;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ResearchStudentServiceImpl implements IResearchStudentService {

    @Autowired
    private ProjectDao projectDao;

    @Autowired
    private ProjectApplicationDao applicationDao;

    @Autowired
    private TaskDao taskDao;

    @Autowired
    private PaperSubmissionDao submissionDao;

    @Autowired
    private PaperReviewDao reviewDao;

    @Autowired
    private ProgressLogDao progressLogDao;

    @Autowired
    private ProjectMemberDao memberDao;

    @Override
    public Page<ProjectVO> getAvailableProjects(Integer page, Integer size, ProjectQueryDTO query) {
        Page<Project> projectPage = new Page<>(page, size);
        QueryWrapper<Project> wrapper = new QueryWrapper<>();
        wrapper.eq("status", "active");

        if (query.getKeyword() != null) {
            wrapper.like("project_name", query.getKeyword())
                    .or().like("abstract_text", query.getKeyword());
        }
        if (query.getProjectType() != null) {
            wrapper.eq("project_type", query.getProjectType());
        }
        if (query.getResearchField() != null) {
            wrapper.eq("research_field", query.getResearchField());
        }

        projectPage = projectDao.selectPage(projectPage, wrapper);

        Page<ProjectVO> result = new Page<>();
        result.setCurrent(projectPage.getCurrent());
        result.setSize(projectPage.getSize());
        result.setTotal(projectPage.getTotal());

        List<ProjectVO> projectVOs = projectPage.getRecords().stream().map(project -> {
            ProjectVO vo = new ProjectVO();
            BeanUtils.copyProperties(project, vo);
            vo.setMemberCount(getMemberCount(project.getId()));
            vo.setTaskCount(getTaskCount(project.getId()));
            return vo;
        }).collect(Collectors.toList());

        result.setRecords(projectVOs);
        return result;
    }

    @Override
    public ProjectVO getProjectDetail(Long projectId) {
        Project project = projectDao.selectById(projectId);
        if (project == null) {
            throw new RuntimeException("项目不存在");
        }

        ProjectVO vo = new ProjectVO();
        BeanUtils.copyProperties(project, vo);
        vo.setMemberCount(getMemberCount(projectId));
        vo.setTaskCount(getTaskCount(projectId));

        return vo;
    }

    @Override
    @Transactional
    public Long applyForProject(Long projectId, String applicationReason) {
        Long currentUserId = AuthenticationHelperUtil.getCurrentUserId();

        // 检查是否已经申请过
        QueryWrapper<ProjectApplication> checkWrapper = new QueryWrapper<>();
        checkWrapper.eq("project_id", projectId)
                .eq("student_id", currentUserId)
                .in("status", "pending", "approved");
        Long existingCount = applicationDao.selectCount(checkWrapper);

        if (existingCount > 0) {
            throw new BusinessException(Code.UPDATE_ERR,"您已经申请过该项目");
        }

        ProjectApplication application = new ProjectApplication();
        application.setProjectId(projectId);
        application.setStudentId(currentUserId);
        application.setApplicationReason(applicationReason);
        application.setStatus("pending");

        applicationDao.insert(application);
        return application.getId();
    }

    @Override
    public List<ProjectApplication> getMyApplications() {
        Long currentUserId = AuthenticationHelperUtil.getCurrentUserId();

        QueryWrapper<ProjectApplication> wrapper = new QueryWrapper<>();
        wrapper.eq("student_id", currentUserId)
                .orderByDesc("created_at");

        return applicationDao.selectList(wrapper);
    }

    @Override
    @Transactional
    public void withdrawApplication(Long applicationId) {
        Long currentUserId = AuthenticationHelperUtil.getCurrentUserId();

        ProjectApplication application = applicationDao.selectById(applicationId);
        if (application == null) {
            throw new BusinessException(Code.DELETE_ERR,"申请不存在");
        }

        if (!application.getStudentId().equals(currentUserId)) {
            throw new BusinessException(Code.DELETE_ERR,"无权操作此申请");
        }

        if (!"pending".equals(application.getStatus())) {
            throw new BusinessException(Code.DELETE_ERR,"只能撤回待审核的申请");
        }

        applicationDao.deleteById(applicationId);
    }

    @Override
    public Page<TaskVO> getMyTasks(Integer page, Integer size) {
        Long currentUserId = AuthenticationHelperUtil.getCurrentUserId();

        Page<Task> taskPage = new Page<>(page, size);
        QueryWrapper<Task> wrapper = new QueryWrapper<>();
        wrapper.eq("student_id", currentUserId)
                .orderByDesc("created_at");

        taskPage = taskDao.selectPage(taskPage, wrapper);

        Page<TaskVO> result = new Page<>();
        result.setCurrent(taskPage.getCurrent());
        result.setSize(taskPage.getSize());
        result.setTotal(taskPage.getTotal());

        List<TaskVO> taskVOs = taskPage.getRecords().stream().map(task -> {
            TaskVO vo = new TaskVO();
            BeanUtils.copyProperties(task, vo);
            // 可以加载项目名称、教师姓名等信息
            Project project = projectDao.selectById(task.getProjectId());
            if (project != null) {
                vo.setProjectName(project.getProjectName());
            }
            return vo;
        }).collect(Collectors.toList());

        result.setRecords(taskVOs);
        return result;
    }

    @Override
    public TaskVO getTaskDetail(Long taskId) {
        Task task = taskDao.selectById(taskId);
        if (task == null) {
            throw new BusinessException(Code.GET_ERR,"任务不存在");
        }

        TaskVO vo = new TaskVO();
        BeanUtils.copyProperties(task, vo);

        // 加载项目信息
        Project project = projectDao.selectById(task.getProjectId());
        if (project != null) {
            vo.setProjectName(project.getProjectName());
        }

        return vo;
    }

    @Override
    @Transactional
    public void updateTaskStatus(Long taskId, String status) {
        Long currentUserId = AuthenticationHelperUtil.getCurrentUserId();

        Task task = taskDao.selectById(taskId);
        if (task == null) {
            throw new BusinessException(Code.UPDATE_ERR,"任务不存在");
        }

        if (!task.getStudentId().equals(currentUserId)) {
            throw new BusinessException(Code.UPDATE_ERR,"无法修改此任务，ID不一致");
        }

        task.setStatus(status);
        task.setUpdatedAt(LocalDateTime.now());
        taskDao.updateById(task);

        // 记录进度日志
        ProgressLog log = new ProgressLog();
        log.setTaskId(taskId);
        log.setUserId(currentUserId);
        log.setProgressType("status_update");
        log.setProgressContent("任务状态更新为：" + status);
        progressLogDao.insert(log);
    }

    @Override
    @Transactional
    public void updateTaskProgress(Long taskId, String progressContent) {
        Long currentUserId = AuthenticationHelperUtil.getCurrentUserId();

        Task task = taskDao.selectById(taskId);
        if (task == null) {
            throw new BusinessException(Code.UPDATE_ERR,"任务不存在");
        }

        if (!task.getStudentId().equals(currentUserId)) {
            throw new BusinessException(Code.UPDATE_ERR,"无权修改此任务，任务id不一致");
        }

        // 记录进度日志
        ProgressLog log = new ProgressLog();
        log.setTaskId(taskId);
        log.setUserId(currentUserId);
        log.setProgressType("progress_update");
        log.setProgressContent(progressContent);
        progressLogDao.insert(log);
    }

    @Override
    @Transactional
    public Long submitPaper(PaperSubmissionDTO dto) {
        Long currentUserId = AuthenticationHelperUtil.getCurrentUserId();
        Long taskId=dto.getTaskId();
        Task task = taskDao.selectById(taskId);
        if (task == null) {
            throw new BusinessException(Code.UPDATE_ERR ,"任务不存在");
        }

        if (!task.getStudentId().equals(currentUserId)) {
            throw new BusinessException(Code.UPDATE_ERR,"无权为此任务提交论文");
        }

        // 检查是否已有提交记录，如果有则创建新版本
        QueryWrapper<PaperSubmission> wrapper = new QueryWrapper<>();
        wrapper.eq("task_id", taskId)
                .eq("student_id", currentUserId)
                .orderByDesc("version");
        List<PaperSubmission> existingSubmissions = submissionDao.selectList(wrapper);

        int nextVersion = existingSubmissions.isEmpty() ? 1 : existingSubmissions.get(0).getVersion() + 1;

        PaperSubmission submission = new PaperSubmission();
        BeanUtils.copyProperties(dto, submission);
        submission.setTaskId(taskId);
        submission.setStudentId(currentUserId);
        submission.setVersion(nextVersion);
        submission.setStatus("submitted");
        submission.setSubmissionTime(LocalDateTime.now());

        submissionDao.insert(submission);

        // 更新任务状态
        task.setStatus("submitted");
        taskDao.updateById(task);

        // 记录进度日志
        ProgressLog log = new ProgressLog();
        log.setTaskId(taskId);
        log.setUserId(currentUserId);
        log.setProgressType("paper_submitted");
        log.setProgressContent("提交论文：" + dto.getTitle() + "（版本" + nextVersion + "）");
        progressLogDao.insert(log);

        return submission.getId();
    }

    @Override
    public List<PaperSubmissionVO> getMySubmissions() {
        Long currentUserId = AuthenticationHelperUtil.getCurrentUserId();

        QueryWrapper<PaperSubmission> wrapper = new QueryWrapper<>();
        wrapper.eq("student_id", currentUserId)
                .orderByDesc("submission_time");

        List<PaperSubmission> submissions = submissionDao.selectList(wrapper);

        return submissions.stream().map(submission -> {
            PaperSubmissionVO vo = new PaperSubmissionVO();
            BeanUtils.copyProperties(submission, vo);

            // 加载任务信息
            Task task = taskDao.selectById(submission.getTaskId());
            if (task != null) {
                vo.setTaskTitle(task.getTitle());
            }

            return vo;
        }).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void updatePaperSubmission(Long submissionId, PaperSubmissionDTO dto) {
        Long currentUserId = AuthenticationHelperUtil.getCurrentUserId();
        dto.setTaskId(submissionDao.selectById(submissionId).getTaskId());
        PaperSubmission submission = submissionDao.selectById(submissionId);
        if (submission == null) {
            throw new BusinessException(Code.UPDATE_ERR,"提交记录不存在");
        }

        if (!submission.getStudentId().equals(currentUserId)) {
            throw new BusinessException(Code.UPDATE_ERR,"无权修改此论文");
        }

        if (!"submitted".equals(submission.getStatus()) && !"needs_revision".equals(submission.getStatus())) {
            throw new BusinessException(Code.UPDATE_ERR,"当前状态不允许被修改");
        }

        BeanUtils.copyProperties(dto, submission);

        submission.setSubmissionTime(LocalDateTime.now());
        submissionDao.updateById(submission);

        // 记录进度日志
        ProgressLog log = new ProgressLog();
        log.setTaskId(submission.getTaskId());
        log.setUserId(currentUserId);
        log.setProgressType("paper_updated");
        log.setProgressContent("更新论文：" + dto.getTitle());
        progressLogDao.insert(log);
    }

    @Override
    public List<PaperReview> getSubmissionReviews(Long submissionId) {
        QueryWrapper<PaperReview> wrapper = new QueryWrapper<>();
        wrapper.eq("submission_id", submissionId)
                .orderByDesc("review_time");

        return reviewDao.selectList(wrapper);
    }

    @Override
    public List<ProgressLog> getTaskProgress(Long taskId) {
        QueryWrapper<ProgressLog> wrapper = new QueryWrapper<>();
        wrapper.eq("task_id", taskId)
                .orderByDesc("created_at");

        return progressLogDao.selectList(wrapper);
    }

    // 辅助方法
    private Integer getMemberCount(Long projectId) {
        QueryWrapper<ProjectMember> wrapper = new QueryWrapper<>();
        wrapper.eq("project_id", projectId)
                .eq("status", "active");
        return Math.toIntExact(memberDao.selectCount(wrapper));
    }

    private Integer getTaskCount(Long projectId) {
        QueryWrapper<Task> wrapper = new QueryWrapper<>();
        wrapper.eq("project_id", projectId);
        return Math.toIntExact(taskDao.selectCount(wrapper));
    }
}