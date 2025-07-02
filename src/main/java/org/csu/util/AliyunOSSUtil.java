// src/main/java/org/csu/util/AliyunOSSUtil.java
package org.csu.util;

import com.aliyun.oss.OSS;
import com.aliyun.oss.common.utils.BinaryUtil;
import com.aliyun.oss.model.MatchMode;
import com.aliyun.oss.model.PolicyConditions;
import org.csu.config.AliyunOSSConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile; // 【修正】 引入MultipartFile类

import java.io.InputStream; // 【修正】 引入InputStream类
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID; // 【修正】 引入UUID类

/**
 * 阿里云OSS工具类
 */
@Component
public class AliyunOSSUtil {

    @Autowired
    private AliyunOSSConfig aliyunOSSConfig;

    @Autowired
    private OSS ossClient;

    public Map<String, String> getPolicy() {
        String host = "https://" + aliyunOSSConfig.getBucketName() + "." + aliyunOSSConfig.getEndpoint();
        String dir = "user-uploads/";

        long expireTime = 300;
        long expireEndTime = System.currentTimeMillis() + expireTime * 1000;
        Date expiration = new Date(expireEndTime);

        PolicyConditions policyConds = new PolicyConditions();
        policyConds.addConditionItem(PolicyConditions.COND_CONTENT_LENGTH_RANGE, 0, 1048576000);
        policyConds.addConditionItem(MatchMode.StartWith, PolicyConditions.COND_KEY, dir);

        String postPolicy = ossClient.generatePostPolicy(expiration, policyConds);
        byte[] binaryData = postPolicy.getBytes(StandardCharsets.UTF_8);
        String encodedPolicy = BinaryUtil.toBase64String(binaryData);
        String postSignature = ossClient.calculatePostSignature(postPolicy);

        Map<String, String> respMap = new LinkedHashMap<>();
        respMap.put("accessid", aliyunOSSConfig.getAccessKeyId());
        respMap.put("policy", encodedPolicy);
        respMap.put("signature", postSignature);
        respMap.put("dir", dir);
        respMap.put("host", host);
        respMap.put("expire", String.valueOf(expireEndTime / 1000));

        return respMap;
    }

    /**
     * 新增：通用文件上传方法
     * @param file 从前端接收的文件
     * @return 上传成功后文件的公共访问URL
     */
    public String uploadFile(MultipartFile file) {
        String originalFilename = file.getOriginalFilename();
        // 使用UUID确保文件名唯一，避免覆盖
        String fileName = "user-uploads/" + UUID.randomUUID().toString() + "_" + originalFilename;

        try {
            InputStream inputStream = file.getInputStream();
            // 上传文件到指定的Bucket和文件名
            ossClient.putObject(aliyunOSSConfig.getBucketName(), fileName, inputStream);

            // 拼接并返回文件的公网访问URL
            return "https://" + aliyunOSSConfig.getBucketName() + "." + aliyunOSSConfig.getEndpoint() + "/" + fileName;

        } catch (Exception e) {
            // 在实际应用中，建议使用日志框架记录错误
            e.printStackTrace();
            throw new RuntimeException("文件上传到OSS时发生错误", e);
        }
    }
}