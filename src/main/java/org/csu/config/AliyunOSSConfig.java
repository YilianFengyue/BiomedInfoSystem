    // src/main/java/org/csu/config/AliyunOSSConfig.java
    package org.csu.config;

    import lombok.Data;
    import org.springframework.boot.context.properties.ConfigurationProperties;
    import org.springframework.stereotype.Component;

    /**
     * 阿里云OSS配置属性类
     * 用于从 application.yml 文件中读取以 "aliyun.oss" 为前缀的配置项
     */
    @Data
    @Component
    @ConfigurationProperties(prefix = "aliyun.oss")
    public class AliyunOSSConfig {
        private String endpoint;
        private String bucketName;
        private String accessKeyId;
        private String accessKeySecret;
    }
