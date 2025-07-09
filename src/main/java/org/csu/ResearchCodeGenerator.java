package org.csu;

import com.baomidou.mybatisplus.generator.FastAutoGenerator;
import com.baomidou.mybatisplus.generator.config.OutputFile;
import com.baomidou.mybatisplus.generator.config.TemplateType;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;

import java.util.Collections;

public class ResearchCodeGenerator {

    public static void main(String[] args) {
        FastAutoGenerator
                // 数据库连接
                .create(
                        "jdbc:mysql://localhost:3306/biomed_info_system?useUnicode=true&characterEncoding=utf8&serverTimezone=GMT%2B8&tinyInt1isBit=true&useInformationSchema=true",
                        "root",
                        "1234"
                )

                /* 1️⃣ 全局配置 -------------------------------------------------- */
                .globalConfig(builder -> builder
                        .author("YinBo")
                        .outputDir(System.getProperty("user.dir") + "/src/main/java")
                        .disableOpenDir()                        // 生成后不自动打开目录
                )

                /* 2️⃣ 包路径配置 ------------------------------------------------ */
                .packageConfig(builder -> builder
                        .parent("org.csu")          // 顶级包
                        .entity("domain")           // Entity 包
                        .mapper("dao")              // Mapper 接口包
                        // XML 单独放到 resources/mappers 下
                        .pathInfo(Collections.singletonMap(
                                OutputFile.xml,
                                System.getProperty("user.dir") + "/src/main/resources/mappers"
                        ))
                )

                /* 3️⃣ 生成策略 -------------------------------------------------- */
                .strategyConfig(builder -> builder
                        // ——仅列科研相关表（res_ 开头）——
                        .addInclude(
                                "res_project",
                                "res_project_member",
                                "res_project_application",
                                "res_task",
                                "res_paper_submission",
                                "res_paper_review",
                                "res_progress_log",
                                "res_achievement"
                        )
                        .addTablePrefix("res_")    // 去掉前缀 res_
                        /* ---- Entity 策略 ---- */
                        .entityBuilder()
                        .enableLombok()
                        .enableFileOverride()      // Entity 允许覆盖


                        /* ---- Mapper 策略 ---- */
                        .mapperBuilder()
                        .enableMapperAnnotation()  // @Mapper
                        .enableFileOverride()      // Mapper 允许覆盖
                        .formatMapperFileName("%sDao")

                        /* ---- 关闭 Service / Controller ---- */
                        .serviceBuilder().disable()
                        .controllerBuilder().disable()
                )

                /* 4️⃣ 模板层面彻底屏蔽不需要的文件 ----------------------------- */
                .templateConfig(t -> t.disable(
                        TemplateType.SERVICE,
                        TemplateType.SERVICE_IMPL,
                        TemplateType.CONTROLLER
                ))

                /* 5️⃣ 选择模板引擎 --------------------------------------------- */
                .templateEngine(new FreemarkerTemplateEngine())
                .execute();
    }
}
