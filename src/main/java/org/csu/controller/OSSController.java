package org.csu.controller;

import lombok.extern.slf4j.Slf4j;
import org.csu.util.AliyunOSSUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
} 