// ResearchTeacherServiceImpl.java
package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.csu.config.BusinessException;
import org.csu.controller.Code;
import org.csu.dao.research.*;
import org.csu.domain.research.*;
import org.csu.dto.*;
import org.csu.service.IResearchTeacherService;
import org.csu.util.AuthenticationHelperUtil;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ResearchTeacherServiceImpl implements IResearchTeacherService {

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

    @Override
    @Transactional
    public Long createProject(ProjectCreateDTO dto) {
        Long currentUserId = AuthenticationHelperUtil.getCurrentUserId();

        Project project = new Project();
        BeanUtils.copyProperties(dto, project);
        project.setPrincipalInvestigator(currentUserId);
        project.setStatus("active");

        projectDao.insert(project);
        return project.getId();
    }

    @Override
    public Page<ProjectVO> getMyProjects(Integer page, Integer size, ProjectQueryDTO query) {
        Long currentUserId = AuthenticationHelperUtil.getCurrentUserId();

        Page<Project> projectPage = new Page<>(page, size);
        QueryWrapper<Project> wrapper = new QueryWrapper<>();
        wrapper.eq("principal_investigator", currentUserId);

        if (query.getKeyword() != null) {
            wrapper.like("project_name", query.getKeyword())
                    .or().like("abstract_text", query.getKeyword());
        }
        if (query.getProjectType() != null) {
            wrapper.eq("project_type", query.getProjectType());
        }
        if (query.getStatus() != null) {
            wrapper.eq("status", query.getStatus());
        }

        projectPage = projectDao.selectPage(projectPage, wrapper);

        Page<ProjectVO> result = new Page<>();
        result.setCurrent(projectPage.getCurrent());
        result.setSize(projectPage.getSize());
        result.setTotal(projectPage.getTotal());

        List<ProjectVO> projectVOs = projectPage.getRecords().stream().map(project -> {
            ProjectVO vo = new ProjectVO();
            BeanUtils.copyProperties(project, vo);
            // 查询成员数量和任务数量
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
            throw new BusinessException(Code.GET_ERR,"项目不存在");
        }

        ProjectVO vo = new ProjectVO();
        BeanUtils.copyProperties(project, vo);
        vo.setMemberCount(getMemberCount(projectId));
        vo.setTaskCount(getTaskCount(projectId));

        return vo;
    }

    @Override
    @Transactional
    public void updateProject(Long projectId, ProjectCreateDTO dto) {
        Project project = projectDao.selectById(projectId);
        if (project == null) {
            throw new BusinessException(Code.UPDATE_ERR,"项目不存在");
        }

        BeanUtils.copyProperties(dto, project);
        project.setUpdatedAt(LocalDateTime.now());
        projectDao.updateById(project);
    }

    @Override
    @Transactional
    public void deleteProject(Long projectId) {
        Project project = projectDao.selectById(projectId);
        if (project == null) {
            // 如果项目不存在，抛出业务异常
            throw new BusinessException(Code.DELETE_ERR, "删除失败：课题不存在");
        }
        projectDao.deleteById(projectId);
    }
    //2申请审核模块
    //2.1 获取待审核申请列表
    @Override
    public Page<ProjectApplication> getPendingApplications(Integer page, Integer size, Long projectId) {
        Page<ProjectApplication> applicationPage = new Page<>(page, size);
        QueryWrapper<ProjectApplication> wrapper = new QueryWrapper<>();
        wrapper.eq("status", "pending");

        if (projectId != null) {
            wrapper.eq("project_id", projectId);
        }

        return applicationDao.selectPage(applicationPage, wrapper);
    }

    @Override
    @Transactional
    public void reviewApplication(ApplicationReviewDTO dto) {
        Long currentUserId = AuthenticationHelperUtil.getCurrentUserId();

        ProjectApplication application = applicationDao.selectById(dto.getApplicationId());
        if (application == null) {
            throw new BusinessException(Code.UPDATE_ERR,"申请不存在");
        }

        application.setStatus(dto.getAction().equals("approve") ? "approved" : "rejected");
        application.setReviewedBy(currentUserId);
        application.setReviewedAt(LocalDateTime.now());
        application.setReviewComment(dto.getReviewComment());

        applicationDao.updateById(application);
    }

    @Override
    public List<ProjectApplication> getProjectApplications(Long projectId) {
        QueryWrapper<ProjectApplication> wrapper = new QueryWrapper<>();
        wrapper.eq("project_id", projectId);
        return applicationDao.selectList(wrapper);
    }

    @Override
    @Transactional
    public Long createTask(TaskCreateDTO dto) {
        Long currentUserId = AuthenticationHelperUtil.getCurrentUserId();

        Task task = new Task();
        BeanUtils.copyProperties(dto, task);
        task.setTeacherId(currentUserId);
        task.setStatus("assigned");
        task.setProgress(java.math.BigDecimal.ZERO);

        taskDao.insert(task);

        // 记录进度日志
        ProgressLog log = new ProgressLog();
        log.setTaskId(task.getId());
        log.setUserId(currentUserId);
        log.setProgressType("task_created");
        log.setProgressContent("创建任务：" + dto.getTitle());
        progressLogDao.insert(log);

        return task.getId();
    }

    @Override
    public Page<TaskVO> getMyTasks(Integer page, Integer size, Long projectId) {
        Long currentUserId = AuthenticationHelperUtil.getCurrentUserId();

        Page<Task> taskPage = new Page<>(page, size);
        QueryWrapper<Task> wrapper = new QueryWrapper<>();
        wrapper.eq("teacher_id", currentUserId);

        if (projectId != null) {
            wrapper.eq("project_id", projectId);
        }

        taskPage = taskDao.selectPage(taskPage, wrapper);

        Page<TaskVO> result = new Page<>();
        result.setCurrent(taskPage.getCurrent());
        result.setSize(taskPage.getSize());
        result.setTotal(taskPage.getTotal());

        List<TaskVO> taskVOs = taskPage.getRecords().stream().map(task -> {
            TaskVO vo = new TaskVO();
            BeanUtils.copyProperties(task, vo);
            // 可以添加学生姓名、项目名称等信息
            return vo;
        }).collect(Collectors.toList());

        result.setRecords(taskVOs);
        return result;
    }

    @Override
    @Transactional
    public void updateTask(Long taskId, TaskCreateDTO dto) {
        Task task = taskDao.selectById(taskId);
        if (task == null) {
            throw new RuntimeException("任务不存在");
        }

        BeanUtils.copyProperties(dto, task);
        task.setUpdatedAt(LocalDateTime.now());
        taskDao.updateById(task);
    }

    @Override
    @Transactional
    public void deleteTask(Long taskId) {
        Task task = taskDao.selectById(taskId);
        if (task == null) {
            // 如果项目不存在，抛出业务异常
            throw new BusinessException(Code.DELETE_ERR, "删除失败：任务不存在");
        }
        taskDao.deleteById(taskId);
    }

    @Override
    public List<PaperSubmissionVO> getTaskSubmissions(Long taskId) {
        QueryWrapper<PaperSubmission> wrapper = new QueryWrapper<>();
        wrapper.eq("task_id", taskId);
        List<PaperSubmission> submissions = submissionDao.selectList(wrapper);

        return submissions.stream().map(submission -> {
            PaperSubmissionVO vo = new PaperSubmissionVO();
            BeanUtils.copyProperties(submission, vo);
            return vo;
        }).collect(Collectors.toList());
    }

    @Override
    public Page<PaperSubmissionVO> getPendingReviews(Integer page, Integer size) {
        Page<PaperSubmission> submissionPage = new Page<>(page, size);
        QueryWrapper<PaperSubmission> wrapper = new QueryWrapper<>();
        wrapper.in("status", "submitted", "reviewing");

        submissionPage = submissionDao.selectPage(submissionPage, wrapper);

        Page<PaperSubmissionVO> result = new Page<>();
        result.setCurrent(submissionPage.getCurrent());
        result.setSize(submissionPage.getSize());
        result.setTotal(submissionPage.getTotal());

        List<PaperSubmissionVO> submissionVOs = submissionPage.getRecords().stream().map(submission -> {
            PaperSubmissionVO vo = new PaperSubmissionVO();
            BeanUtils.copyProperties(submission, vo);
            return vo;
        }).collect(Collectors.toList());

        result.setRecords(submissionVOs);
        return result;
    }

    @Override
    public PaperSubmission getSubmissionDetail(Long submissionId) {
        return submissionDao.selectById(submissionId);
    }

    @Override
    @Transactional
    public Long submitReview(ReviewCreateDTO dto) {
        Long currentUserId = AuthenticationHelperUtil.getCurrentUserId();

        PaperReview review = new PaperReview();
        BeanUtils.copyProperties(dto, review);
        review.setReviewerId(currentUserId);
        review.setReviewTime(LocalDateTime.now());

        reviewDao.insert(review);

        // 更新提交状态
        PaperSubmission submission = submissionDao.selectById(dto.getSubmissionId());
        if (submission != null) {
            submission.setStatus("reviewing");
            submissionDao.updateById(submission);
        }

        return review.getId();
    }

    @Override
    @Transactional
    public void updateReview(Long reviewId, ReviewCreateDTO dto) {
        PaperReview review = reviewDao.selectById(reviewId);
        if (review == null) {
            throw new RuntimeException("评审记录不存在");
        }

        BeanUtils.copyProperties(dto, review);
        review.setReviewTime(LocalDateTime.now());
        reviewDao.updateById(review);
    }

    // 辅助方法
    private Integer getMemberCount(Long projectId) {
        // 实现获取项目成员数量的逻辑
        return 0;
    }

    private Integer getTaskCount(Long projectId) {
        QueryWrapper<Task> wrapper = new QueryWrapper<>();
        wrapper.eq("project_id", projectId);
        return Math.toIntExact(taskDao.selectCount(wrapper));
    }
}