// ResearchController.java
package org.csu.controller;

import org.csu.domain.research.Achievement;
import org.csu.dto.ProjectStatDTO;
import org.csu.service.IResearchCommonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("research")
public class ResearchController {

    @Autowired
    private IResearchCommonService researchCommonService;

    @GetMapping("/projects/{id}/statistics")
    public Result<ProjectStatDTO> getProjectStatistics(@PathVariable Long id) {
        ProjectStatDTO statistics = researchCommonService.getProjectStatistics(id);
        return Result.success(statistics);
    }

    @GetMapping("/projects/{id}/achievements")
    public Result<List<Achievement>> getProjectAchievements(@PathVariable Long id) {
        List<Achievement> achievements = researchCommonService.getProjectAchievements(id);
        return Result.success(achievements);
    }

    @PostMapping("/upload")
    public Result<String> uploadFile(@RequestParam("file") MultipartFile file) {
        try {
            String fileName = file.getOriginalFilename();
            byte[] fileData = file.getBytes();
            String fileUrl = researchCommonService.uploadFile(fileName, fileData);
            return Result.success(fileUrl, "文件上传成功");
        } catch (IOException e) {
            return Result.error("文件上传失败：" + e.getMessage());
        }
    }

    @GetMapping("/download")
    public ResponseEntity<byte[]> downloadFile(@RequestParam String fileUrl) {
        try {
            byte[] fileData = researchCommonService.downloadFile(fileUrl);
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .body(fileData);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }
}