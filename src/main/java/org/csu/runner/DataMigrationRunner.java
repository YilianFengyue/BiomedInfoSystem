package org.csu.runner;

import org.csu.domain.node.*;
import org.csu.domain.relationship.HerbComponent;
import org.csu.repository.*;
import org.springframework.boot.CommandLineRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

//@Component
public class DataMigrationRunner implements CommandLineRunner {

    private final JdbcTemplate jdbcTemplate;
    private final DiseaseRepository diseaseRepository;
    private final SymptomRepository symptomRepository;
    private final SyndromeRepository syndromeRepository;
    private final FormulaRepository formulaRepository;
    private final HerbRepository herbRepository;

    public DataMigrationRunner(JdbcTemplate jdbcTemplate, DiseaseRepository diseaseRepository,
                               SymptomRepository symptomRepository, SyndromeRepository syndromeRepository,
                               FormulaRepository formulaRepository, HerbRepository herbRepository) {
        this.jdbcTemplate = jdbcTemplate;
        this.diseaseRepository = diseaseRepository;
        this.symptomRepository = symptomRepository;
        this.syndromeRepository = syndromeRepository;
        this.formulaRepository = formulaRepository;
        this.herbRepository = herbRepository;
    }

    @Override
    @Transactional
    public void run(String... args) throws Exception {
//        if (formulaRepository.count() > 0) {
//            System.out.println("Neo4j数据库中已有数据，跳过本次数据迁移。");
//            return;
//        }

        System.out.println("--- [数据迁移] 开始 ---");
        migrateNodes();
        migrateRelationships();
        System.out.println("--- [数据迁移] 成功结束 ---");
    }

    private void migrateNodes() {
        System.out.println("步骤1/2: 正在迁移所有基础节点...");

        // **修正部分：只查询 herb 表中存在的列**
        jdbcTemplate.queryForList("SELECT name, description FROM herb").forEach(row -> {
            String name = (String) row.get("name");
            herbRepository.findByName(name).orElseGet(() -> {
                HerbNode node = new HerbNode();
                node.setName(name);
                // 将MySQL的description(简介/药用价值描述) 映射到 Neo4j实体中的effect(功效)字段
                node.setDescription((String) row.get("description"));
                node.setEffect((String) row.get("description"));
                return herbRepository.save(node);
            });
        });
        System.out.println("  - 药材节点迁移完毕。");

        // **修正部分：只查询 disease 表中存在的列，并进行合理映射**
        jdbcTemplate.queryForList("SELECT name, pathogenesis FROM disease").forEach(row -> {
            String name = (String) row.get("name");
            diseaseRepository.findByName(name).orElseGet(() -> {
                DiseaseNode node = new DiseaseNode();
                node.setName(name);
                // 将MySQL的pathogenesis(病因病机) 映射到 Neo4j实体中的description字段
                node.setDescription((String) row.get("pathogenesis"));
                return diseaseRepository.save(node);
            });
        });
        System.out.println("  - 疾病节点迁移完毕。");

        // 迁移方剂 (Formula) - 此部分无误，保持不变
        jdbcTemplate.queryForList("SELECT name, source, composition, `usage`, function_effect, main_treatment FROM formula").forEach(row -> {
            String name = (String) row.get("name");
            formulaRepository.findByName(name).orElseGet(() -> {
                FormulaNode node = new FormulaNode();
                node.setName(name);
                node.setDescription((String) row.get("function_effect"));
                node.setSource((String) row.get("source"));
                node.setComposition((String) row.get("composition"));
                node.setUsage((String) row.get("usage"));
                node.setFunction((String) row.get("function_effect"));
                node.setIndication((String) row.get("main_treatment"));
                return formulaRepository.save(node);
            });
        });
        System.out.println("  - 方剂节点迁移完毕。");
        System.out.println("所有基础节点迁移完成。");
    }

    private void migrateRelationships() {
        // 此处的关系迁移逻辑是正确的，因为它们基于JOIN查询，已经确保了数据存在。
        // 所以这部分代码保持不变。
        System.out.println("步骤2/2: 正在创建节点间的关系...");

        // 创建 (Disease)-[:HAS_SYMPTOM]->(Symptom) 关系
        jdbcTemplate.queryForList("SELECT name, symptoms, pathogenesis FROM disease").forEach(row -> {
            String diseaseName = (String) row.get("name");
            String symptomsStr = (String) row.get("symptoms");
            String pathogenesis = (String) row.get("pathogenesis");
            diseaseRepository.findByName(diseaseName).ifPresent(diseaseNode -> {
                if (symptomsStr != null && !symptomsStr.isEmpty()) {
                    Arrays.stream(symptomsStr.split("，|、| "))
                            .map(String::trim).filter(s -> !s.isEmpty())
                            .forEach(symptomName -> {
                                SymptomNode symptomNode = symptomRepository.findByName(symptomName).orElseGet(() -> {
                                    SymptomNode newSymptom = new SymptomNode();
                                    newSymptom.setName(symptomName);
                                    newSymptom.setDescription("临床表现为: " + symptomName);
                                    return symptomRepository.save(newSymptom);
                                });
                                if (diseaseNode.getSymptoms() == null) diseaseNode.setSymptoms(new HashSet<>());
                                diseaseNode.getSymptoms().add(symptomNode);
                            });
                    diseaseRepository.save(diseaseNode);
                }
            });
        });
        System.out.println("  - [疾病-症状] 关系创建完毕。");

        // 创建 (Formula)-[:CONTAINS]->(Herb) 关系
        String formulaHerbSql = "SELECT f.name AS fn, h.name AS hn, fh.dosage, fh.role " +
                "FROM formula_herb fh " +
                "JOIN formula f ON fh.formula_id = f.id " +
                "JOIN herb h ON fh.herb_id = h.id";
        jdbcTemplate.queryForList(formulaHerbSql).forEach(row -> {
            String formulaName = (String) row.get("fn");
            String herbName = (String) row.get("hn");
            formulaRepository.findByName(formulaName).ifPresent(formula -> {
                herbRepository.findByName(herbName).ifPresent(herb -> {
                    if (formula.getHerbComponents() == null) formula.setHerbComponents(new HashSet<>());
                    boolean relationshipExists = formula.getHerbComponents().stream()
                            .anyMatch(comp -> comp.getHerb().getName().equals(herbName));
                    if (!relationshipExists) {
                        HerbComponent component = new HerbComponent(herb, (String) row.get("dosage"), (String) row.get("role"));
                        formula.getHerbComponents().add(component);
                        formulaRepository.save(formula);
                    }
                });
            });
        });
        System.out.println("  - [方剂-药材] 关系创建完毕。");

        // 创建 (Formula)-[:TREATS_DISEASE]->(Disease) 和相关证候关系
        String formulaDiseaseSql = "SELECT f.name as fn, d.name as dn, fd.syndrome as sn " +
                "FROM formula_disease fd " +
                "JOIN formula f ON fd.formula_id = f.id " +
                "JOIN disease d ON fd.disease_id = d.id";
        jdbcTemplate.queryForList(formulaDiseaseSql).forEach(row -> {
            String formulaName = (String) row.get("fn");
            String diseaseName = (String) row.get("dn");
            String syndromeName = (String) row.get("sn");

            formulaRepository.findByName(formulaName).ifPresent(formula -> {
                diseaseRepository.findByName(diseaseName).ifPresent(disease -> {
                    // 建立 Formula -> Disease 关系
                    if (formula.getTreatedDiseases() == null) formula.setTreatedDiseases(new HashSet<>());
                    formula.getTreatedDiseases().add(disease);

                    // 如果有关联的证候信息
                    if (syndromeName != null && !syndromeName.isEmpty()) {
                        SyndromeNode syndromeNode = syndromeRepository.findByName(syndromeName).orElseGet(() -> {
                            SyndromeNode newSyndrome = new SyndromeNode();
                            newSyndrome.setName(syndromeName);
                            newSyndrome.setDescription(syndromeName);
                            return syndromeRepository.save(newSyndrome);
                        });
                        // 建立 Formula -> Syndrome 关系
                        if (formula.getTreatedSyndromes() == null) formula.setTreatedSyndromes(new HashSet<>());
                        formula.getTreatedSyndromes().add(syndromeNode);

                        // 建立 Disease -> Syndrome 关系
                        if (disease.getSyndromes() == null) disease.setSyndromes(new HashSet<>());
                        disease.getSyndromes().add(syndromeNode);
                        diseaseRepository.save(disease);
                    }
                    formulaRepository.save(formula);
                });
            });
        });
        System.out.println("  - [方剂-疾病] 及相关证候关系创建完毕。");
    }
}