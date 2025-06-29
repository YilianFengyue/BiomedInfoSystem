// src/main/java/org/csu/util/AliyunOSSUtil.java
package org.csu.util;

import com.aliyun.oss.OSS;
import com.aliyun.oss.common.utils.BinaryUtil;
import com.aliyun.oss.model.MatchMode;
import com.aliyun.oss.model.PolicyConditions;
import org.csu.config.AliyunOSSConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 阿里云OSS工具类
 * 主要用于生成前端直传所需要的Policy和签名
 */
@Component
public class AliyunOSSUtil {

    @Autowired
    private AliyunOSSConfig aliyunOSSConfig;

    @Autowired
    private OSS ossClient;

    /**
     * 生成前端上传所需的Policy和签名等信息
     * @return 包含policy、signature等信息的Map
     */
    public Map<String, String> getPolicy() {
        // host的格式为 bucketname.endpoint
        String host = "https://" + aliyunOSSConfig.getBucketName() + "." + aliyunOSSConfig.getEndpoint();
        // callbackUrl为上传回调服务器的URL，请根据实际情况设置
        // String callbackUrl = "http://88.88.88.88:8888"; 
        String dir = "user-uploads/"; // 设置上传到OSS的哪个文件夹

        long expireTime = 300; // 签名有效期300秒
        long expireEndTime = System.currentTimeMillis() + expireTime * 1000;
        Date expiration = new Date(expireEndTime);
        
        PolicyConditions policyConds = new PolicyConditions();
        // 设置上传文件的大小限制，例如1GB
        policyConds.addConditionItem(PolicyConditions.COND_CONTENT_LENGTH_RANGE, 0, 1048576000);
        // 设置上传目录
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
        // respMap.put("callback", "your_callback_data"); // 如果需要回调，则添加此项

        return respMap;
    }
}