package org.csu.config;

import org.neo4j.driver.Driver;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.neo4j.core.transaction.Neo4jTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@EnableTransactionManagement // 在这里也加上，确保此配置被识别为事务配置
public class Neo4jConfig {

    /**
     * 显式定义Neo4j的事务管理器Bean。
     * 当Spring遇到涉及Neo4j仓库的@Transactional方法时，
     * 会使用这个我们明确定义的事务管理器。
     * 这解决了在多数据源环境下的自动配置歧义问题。
     */
    @Bean
    public Neo4jTransactionManager transactionManager(Driver driver) {
        return new Neo4jTransactionManager(driver);
    }
}