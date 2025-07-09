// ResearchCommonServiceImpl.java
package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.csu.dao.research.*;
import org.csu.domain.research.*;
import org.csu.dto.ProjectStatDTO;
import org.csu.service.IResearchCommonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ResearchCommonServiceImpl implements IResearchCommonService {

    @Autowired
    private ProjectDao projectDao;

    @Autowired
    private TaskDao taskDao;

    @Autowired
    private PaperSubmissionDao submissionDao;

    @Autowired
    private ProjectMemberDao memberDao;

    @Autowired
    private AchievementDao achievementDao;

    @Override
    public ProjectStatDTO getProjectStatistics(Long projectId) {
        Project project = projectDao.selectById(projectId);
        if (project == null) {
            throw new RuntimeException("项目不存在");
        }

        ProjectStatDTO stat = new ProjectStatDTO();
        stat.setProjectId(projectId);
        stat.setProjectName(project.getProjectName());

        // 统计任务数量
        QueryWrapper<Task> taskWrapper = new QueryWrapper<>();
        taskWrapper.eq("project_id", projectId);
        int totalTasks = Math.toIntExact(taskDao.selectCount(taskWrapper));
        stat.setTotalTasks(totalTasks);

        // 统计已完成任务数量
        taskWrapper.eq("status", "completed");
        int completedTasks = Math.toIntExact(taskDao.selectCount(taskWrapper));
        stat.setCompletedTasks(completedTasks);

        // 统计成员数量
        QueryWrapper<ProjectMember> memberWrapper = new QueryWrapper<>();
        memberWrapper.eq("project_id", projectId).eq("status", "active");
        int totalMembers = Math.toIntExact(memberDao.selectCount(memberWrapper));
        stat.setTotalMembers(totalMembers);

        // 统计提交数量
        QueryWrapper<PaperSubmission> submissionWrapper = new QueryWrapper<>();
        submissionWrapper.in("task_id", getProjectTaskIds(projectId));
        int totalSubmissions = Math.toIntExact(submissionDao.selectCount(submissionWrapper));
        stat.setTotalSubmissions(totalSubmissions);

        // 统计已通过的提交数量
        submissionWrapper.eq("status", "approved");
        int approvedSubmissions = Math.toIntExact(submissionDao.selectCount(submissionWrapper));
        stat.setApprovedSubmissions(approvedSubmissions);

        // 计算完成率
        double completionRate = totalTasks > 0 ? (double) completedTasks / totalTasks * 100 : 0;
        stat.setCompletionRate(completionRate);

        // 设置进度状态
        if (completionRate >= 90) {
            stat.setProgressStatus("excellent");
        } else if (completionRate >= 70) {
            stat.setProgressStatus("good");
        } else if (completionRate >= 50) {
            stat.setProgressStatus("normal");
        } else {
            stat.setProgressStatus("behind");
        }

        return stat;
    }

    @Override
    public List<Achievement> getProjectAchievements(Long projectId) {
        QueryWrapper<Achievement> wrapper = new QueryWrapper<>();
        wrapper.eq("project_id", projectId)
                .eq("status", "approved")
                .orderByDesc("publish_date");

        return achievementDao.selectList(wrapper);
    }

    @Override
    public String uploadFile(String fileName, byte[] fileData) {
        // 这里应该集成你现有的文件上传服务
        // 比如阿里云OSS或其他云存储
        // 返回文件的访问URL
        throw new RuntimeException("请实现文件上传逻辑");
    }

    @Override
    public byte[] downloadFile(String fileUrl) {
        // 这里应该集成你现有的文件下载服务
        // 根据URL下载文件并返回字节数组
        throw new RuntimeException("请实现文件下载逻辑");
    }

    // 辅助方法
    private List<Long> getProjectTaskIds(Long projectId) {
        QueryWrapper<Task> wrapper = new QueryWrapper<>();
        wrapper.eq("project_id", projectId).select("id");
        return taskDao.selectList(wrapper).stream()
                .map(Task::getId)
                .collect(java.util.stream.Collectors.toList());
    }
}