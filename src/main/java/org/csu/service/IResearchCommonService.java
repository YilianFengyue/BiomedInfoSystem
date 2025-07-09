package org.csu.service;

import org.csu.domain.research.*;
import org.csu.dto.ProjectStatDTO;

import java.util.List;

public interface IResearchCommonService {

    // 统计数据
    ProjectStatDTO getProjectStatistics(Long projectId);
    List<Achievement> getProjectAchievements(Long projectId);

    // 文件处理
    String uploadFile(String fileName, byte[] fileData);
    byte[] downloadFile(String fileUrl);
}