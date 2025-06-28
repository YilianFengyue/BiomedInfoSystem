package org.csu; // 你可以根据需要修改包路径

import com.baomidou.mybatisplus.generator.FastAutoGenerator;
import com.baomidou.mybatisplus.generator.config.OutputFile;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;

import java.util.Collections;

public class CodeGenerator {
    public static void main(String[] args) {
        // 数据库连接信息，已配置为你的生物医药项目
        FastAutoGenerator.create("jdbc:mysql://localhost:3306/biomed_info_system?useUnicode=true&characterEncoding=utf8&serverTimezone=GMT%2B8&tinyInt1isBit=true&useInformationSchema=true", "root", "1234")

                // 1. 全局配置
                .globalConfig(builder -> {
                    builder.author("YinBo") // 设置作者
                            .outputDir(System.getProperty("user.dir") + "/src/main/java") // 指定输出目录
                            .disableOpenDir(); // 执行后不自动打开输出文件夹
                })

                // 2. 包配置 (完全按照你的新风格)
                .packageConfig(builder -> {
                    builder.parent("org.csu") // 设置父包名
                            .entity("domain") // 实体类包名
                            .mapper("dao") // Mapper接口包名
                            .service("service") // Service接口包名
                            .serviceImpl("service.impl") // Service实现类包名
                            .controller("controller") // Controller包名
                            // 自定义XML输出路径
                            .pathInfo(Collections.singletonMap(OutputFile.xml, System.getProperty("user.dir") + "/src/main/resources/mappers"));
                })

                // 3. 策略配置
                .strategyConfig(builder -> {
                    // **关键：已为你填入项目中所有的表名**
                    builder.addInclude(
                                    "herb", "herb_location", "herb_image", "herb_growth_data",
                                    "herb_growth_data_history", "users", "user_profiles",
                                    "edu_categories", "edu_resources", "edu_videos", "edu_resource_video_link"
                            )
                            // Entity 策略配置
                            .entityBuilder()
                            .enableLombok() // 启用 Lombok
                            .enableFileOverride() // 开启文件覆盖（重新执行会覆盖已有文件）
                            // Controller 策略配置
                            .controllerBuilder()
                            .enableRestStyle() // 启用 REST 风格的 Controller
                            .enableHyphenStyle() // URL开启驼峰转连字符
                            // Mapper 策略配置
                            .mapperBuilder()
                            .enableMapperAnnotation() // 开启 @Mapper 注解
                            .formatMapperFileName("%sDao"); // Mapper文件名格式为 "XxxDao"
                })

                // 4. 模板引擎配置
                .templateEngine(new FreemarkerTemplateEngine())
                .execute();
    }
}