package org.csu.controller;

import lombok.extern.slf4j.Slf4j;
import org.csu.util.AliyunOSSUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/oss")
public class OSSController {

    @Autowired
    private AliyunOSSUtil aliyunOSSUtil;

    @GetMapping("/policy")
    public Result getPolicy() {
        try {
            log.info("开始获取OSS上传策略(Policy)...");
            Map<String, String> policy = aliyunOSSUtil.getPolicy();
            log.info("OSS上传策略获取成功");
            return new Result(Code.GET_OK, policy, "获取上传策略成功");
        } catch (Exception e) {
            log.error("获取OSS上传策略时发生未知异常", e);
            return new Result(Code.SYSTEM_ERR, null, "服务器内部异常，请查看日志");
        }
    }
} 