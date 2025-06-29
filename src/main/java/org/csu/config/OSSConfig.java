    // src/main/java/org/csu/config/OSSConfig.java
    package org.csu.config;

    import com.aliyun.oss.OSS;
    import com.aliyun.oss.OSSClientBuilder;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.context.annotation.Bean;
    import org.springframework.context.annotation.Configuration;

    /**
     * Spring配置类，专门用于创建阿里云OSS客户端实例(Bean)
     */
    @Configuration
    public class OSSConfig {

        @Autowired
        private AliyunOSSConfig aliyunOSSConfig;

        /**
         * 这个方法会创建一个OSS客户端实例，并将其作为一个Bean注册到Spring容器中。
         * Spring容器会自动管理这个Bean的生命周期。
         * 当其他组件(如AliyunOSSUtil)需要一个OSS实例时，Spring会自动将这个Bean注入进去。
         * @return 初始化好的OSS客户端实例
         */
        @Bean
        public OSS ossClient() {
            // 从配置属性类中获取endpoint、accessKeyId和accessKeySecret
            return new OSSClientBuilder().build(
                    aliyunOSSConfig.getEndpoint(),
                    aliyunOSSConfig.getAccessKeyId(),
                    aliyunOSSConfig.getAccessKeySecret()
            );
        }
    }