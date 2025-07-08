package org.csu.runner;

import org.csu.domain.node.*;
import org.csu.domain.relationship.HerbComponent;
import org.csu.repository.*;
import org.neo4j.driver.Driver;
import org.neo4j.driver.Session;
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
    private final Driver neo4jDriver;

    public DataMigrationRunner(JdbcTemplate jdbcTemplate, DiseaseRepository diseaseRepository,
                               SymptomRepository symptomRepository, SyndromeRepository syndromeRepository,
                               FormulaRepository formulaRepository, HerbRepository herbRepository,
                               Driver neo4jDriver) {
        this.jdbcTemplate = jdbcTemplate;
        this.diseaseRepository = diseaseRepository;
        this.symptomRepository = symptomRepository;
        this.syndromeRepository = syndromeRepository;
        this.formulaRepository = formulaRepository;
        this.herbRepository = herbRepository;
        this.neo4jDriver = neo4jDriver;
    }

    @Override
    @Transactional
    public void run(String... args) throws Exception {
        System.out.println("--- [数据迁移] 开始 ---");
        clearDatabase();
        migrateNodes();
        migrateRelationships();
        System.out.println("--- [数据迁移] 成功结束 ---");
    }

    private void clearDatabase() {
        System.out.println("清空 Neo4j 所有节点和关系...");
        try (Session session = neo4jDriver.session()) {
            session.run("MATCH (n) DETACH DELETE n");
        }
        System.out.println("清空完成！");
    }

    private void migrateNodes() {
        System.out.println("步骤1/2: 正在迁移所有基础节点...");

        jdbcTemplate.queryForList("SELECT name, description FROM herb").forEach(row -> {
            String name = (String) row.get("name");
            herbRepository.findByName(name).orElseGet(() -> {
                HerbNode node = new HerbNode();
                node.setName(name);
                node.setEffect((String) row.get("description"));
                return herbRepository.save(node);
            });
        });
        System.out.println("  - 药材节点迁移完毕。");

        jdbcTemplate.queryForList("SELECT name, pathogenesis FROM disease").forEach(row -> {
            String name = (String) row.get("name");
            diseaseRepository.findByName(name).orElseGet(() -> {
                DiseaseNode node = new DiseaseNode();
                node.setName(name);
                node.setDescription((String) row.get("pathogenesis"));
                return diseaseRepository.save(node);
            });
        });
        System.out.println("  - 疾病节点迁移完毕。");

        jdbcTemplate.queryForList("SELECT name, source, composition, `usage`, function_effect, main_treatment FROM formula").forEach(row -> {
            String name = (String) row.get("name");
            formulaRepository.findByName(name).orElseGet(() -> {
                FormulaNode node = new FormulaNode();
                node.setName(name);
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
        System.out.println("步骤2/2: 正在创建节点间的关系...");

        jdbcTemplate.queryForList("SELECT name, symptoms FROM disease").forEach(row -> {
            String diseaseName = (String) row.get("name");
            String symptomsStr = (String) row.get("symptoms");
            diseaseRepository.findByName(diseaseName).ifPresent(diseaseNode -> {
                if (symptomsStr != null && !symptomsStr.isEmpty()) {
                    Arrays.stream(symptomsStr.split("，|、| "))
                            .map(String::trim).filter(s -> !s.isEmpty())
                            .forEach(symptomName -> {
                                SymptomNode symptomNode = symptomRepository.findByName(symptomName).orElseGet(() -> {
                                    SymptomNode newSymptom = new SymptomNode();
                                    newSymptom.setName(symptomName);
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
                    if (formula.getTreatedDiseases() == null) formula.setTreatedDiseases(new HashSet<>());
                    formula.getTreatedDiseases().add(disease);

                    if (syndromeName != null && !syndromeName.isEmpty()) {
                        SyndromeNode syndromeNode = syndromeRepository.findByName(syndromeName).orElseGet(() -> {
                            SyndromeNode newSyndrome = new SyndromeNode();
                            newSyndrome.setName(syndromeName);
                            return syndromeRepository.save(newSyndrome);
                        });
                        if (formula.getTreatedSyndromes() == null) formula.setTreatedSyndromes(new HashSet<>());
                        formula.getTreatedSyndromes().add(syndromeNode);

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
