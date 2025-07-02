// src/main/java/org/csu/controller/OSSController.java
package org.csu.controller;

import lombok.extern.slf4j.Slf4j;
import org.csu.util.AliyunOSSUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile; // 【修正】 引入MultipartFile类

import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/oss")
@CrossOrigin(origins = "*")
public class OSSController {

    @Autowired
    private AliyunOSSUtil aliyunOSSUtil;

    @GetMapping("/policy")
    public Result<Map<String, String>> getPolicy() {
        try {
            log.info("开始获取OSS上传策略(Policy)...");
            Map<String, String> policy = aliyunOSSUtil.getPolicy();
            log.info("OSS上传策略获取成功");
            return Result.success(policy);
        } catch (Exception e) {
            log.error("获取OSS上传策略时发生未知异常", e);
            return Result.error(Code.SYSTEM_ERR, "服务器内部异常，无法获取上传策略");
        }
    }

    /**
     * 处理通用文件上传的接口
     * @param file 前端上传的文件，@RequestParam("file")需与前端的FormData key一致
     * @return 包含文件URL的Result对象
     */
    @PostMapping("/upload_general_file")
    public Result<String> uploadGeneralFile(@RequestParam("file") MultipartFile file) {
        // 【修正】MultipartFile对象本身不能为null，但其内容可以为空
        if (file.isEmpty()) {
            return Result.error(Code.VALIDATE_ERR, "上传的文件不能为空");
        }
        try {
            String fileUrl = aliyunOSSUtil.uploadFile(file);
            // 【修正】调用正确的Result.success方法，将URL作为数据，并附带成功消息
            return Result.success(fileUrl, "文件上传成功");
        } catch (Exception e) {
            log.error("文件上传失败:", e);
            return Result.error(Code.SYSTEM_ERR, "文件上传失败，请稍后重试");
        }
    }
}