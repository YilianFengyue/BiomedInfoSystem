package org.csu.service.impl;

import org.csu.domain.node.*;
import org.csu.domain.relationship.HerbComponent;
import org.csu.config.ResourceNotFoundException;
import org.csu.repository.*;
import org.csu.service.TcmService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class TcmServiceImpl implements TcmService {

    // 注入所有需要的Repository
    private final FormulaRepository formulaRepository;
    private final HerbRepository herbRepository;
    private final DiseaseRepository diseaseRepository;
    private final SymptomRepository symptomRepository;
    private final SyndromeRepository syndromeRepository;
    private final MeridianRepository meridianRepository;
    private final AcupointRepository acupointRepository;

    public TcmServiceImpl(FormulaRepository formulaRepository, HerbRepository herbRepository, DiseaseRepository diseaseRepository, SymptomRepository symptomRepository, SyndromeRepository syndromeRepository, MeridianRepository meridianRepository, AcupointRepository acupointRepository) {
        this.formulaRepository = formulaRepository;
        this.herbRepository = herbRepository;
        this.diseaseRepository = diseaseRepository;
        this.symptomRepository = symptomRepository;
        this.syndromeRepository = syndromeRepository;
        this.meridianRepository = meridianRepository;
        this.acupointRepository = acupointRepository;
    }

    // --- 方剂查询 ---
    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getGraphDataForFormula(String name) {
        FormulaNode formula = formulaRepository.findByName(name).orElseThrow(() -> new ResourceNotFoundException("未找到方剂: " + name));
        Set<Map<String, Object>> nodes = new HashSet<>();
        Set<Map<String, Object>> links = new HashSet<>();
        nodes.add(createNode(formula.getId(), formula.getName(), "方剂"));
        // ... (此处省略之前已提供的完整实现) ...
        return Map.of("nodes", nodes, "links", links);
    }

    // --- 疾病查询 ---
    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getGraphDataForDisease(String name) {
        DiseaseNode disease = diseaseRepository.findByName(name).orElseThrow(() -> new ResourceNotFoundException("未找到疾病: " + name));
        Set<Map<String, Object>> nodes = new HashSet<>();
        Set<Map<String, Object>> links = new HashSet<>();
        nodes.add(createNode(disease.getId(), disease.getName(), "疾病"));
        if (disease.getSymptoms() != null) disease.getSymptoms().forEach(s -> {
            nodes.add(createNode(s.getId(), s.getName(), "症状"));
            links.add(createLink(disease.getId(), s.getId(), "表现为"));
        });
        formulaRepository.findByTreatedDiseasesName(name).forEach(f -> {
            nodes.add(createNode(f.getId(), f.getName(), "方剂"));
            links.add(createLink(f.getId(), disease.getId(), "治疗"));
        });
        return Map.of("nodes", nodes, "links", links);
    }

    // --- 药材查询 ---
    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getGraphDataForHerb(String name) {
        HerbNode herb = herbRepository.findByName(name).orElseThrow(() -> new ResourceNotFoundException("未找到药材: " + name));
        Set<Map<String, Object>> nodes = new HashSet<>();
        Set<Map<String, Object>> links = new HashSet<>();
        nodes.add(createNode(herb.getId(), herb.getName(), "药材"));
        formulaRepository.findByHerbComponentsHerbName(name).forEach(f -> {
            nodes.add(createNode(f.getId(), f.getName(), "方剂"));
            links.add(createLink(f.getId(), herb.getId(), "包含"));
        });
        return Map.of("nodes", nodes, "links", links);
    }

    // --- 症状查询 ---
    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getGraphDataForSymptom(String name) {
        SymptomNode symptom = symptomRepository.findByName(name).orElseThrow(() -> new ResourceNotFoundException("未找到症状: " + name));
        Set<Map<String, Object>> nodes = new HashSet<>();
        Set<Map<String, Object>> links = new HashSet<>();
        nodes.add(createNode(symptom.getId(), symptom.getName(), "症状"));
        diseaseRepository.findBySymptomsName(name).forEach(d -> {
            nodes.add(createNode(d.getId(), d.getName(), "疾病"));
            links.add(createLink(d.getId(), symptom.getId(), "表现为"));
        });
        return Map.of("nodes", nodes, "links", links);
    }

    // --- 证候查询 ---
    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getGraphDataForSyndrome(String name) {
        SyndromeNode syndrome = syndromeRepository.findByName(name).orElseThrow(() -> new ResourceNotFoundException("未找到证候: " + name));
        Set<Map<String, Object>> nodes = new HashSet<>();
        Set<Map<String, Object>> links = new HashSet<>();
        nodes.add(createNode(syndrome.getId(), syndrome.getName(), "证候"));
        formulaRepository.findByTreatedSyndromesName(name).forEach(f -> {
            nodes.add(createNode(f.getId(), f.getName(), "方剂"));
            links.add(createLink(f.getId(), syndrome.getId(), "治疗"));
        });
        diseaseRepository.findBySyndromesName(name).forEach(d -> {
            nodes.add(createNode(d.getId(), d.getName(), "疾病"));
            links.add(createLink(d.getId(), syndrome.getId(), "包含"));
        });
        return Map.of("nodes", nodes, "links", links);
    }

    // --- 经络查询 ---
    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getGraphDataForMeridian(String name) {
        MeridianNode meridian = meridianRepository.findByName(name).orElseThrow(() -> new ResourceNotFoundException("未找到经络: " + name));
        Set<Map<String, Object>> nodes = new HashSet<>();
        Set<Map<String, Object>> links = new HashSet<>();
        nodes.add(createNode(meridian.getId(), meridian.getName(), "经络"));
        //... 根据需要添加反向查询逻辑，例如查找归经于此的药材 ...
        return Map.of("nodes", nodes, "links", links);
    }

    // --- 穴位查询 ---
    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getGraphDataForAcupoint(String name) {
        AcupointNode acupoint = acupointRepository.findByName(name).orElseThrow(() -> new ResourceNotFoundException("未找到穴位: " + name));
        Set<Map<String, Object>> nodes = new HashSet<>();
        Set<Map<String, Object>> links = new HashSet<>();
        nodes.add(createNode(acupoint.getId(), acupoint.getName(), "穴位"));
        meridianRepository.findByAcupointsName(name).forEach(m -> {
            nodes.add(createNode(m.getId(), m.getName(), "经络"));
            links.add(createLink(m.getId(), acupoint.getId(), "包含"));
        });
        return Map.of("nodes", nodes, "links", links);
    }


    private Map<String, Object> createNode(Long id, String name, String category) {
        Map<String, Object> node = new HashMap<>();
        // id统一转为字符串，因为很多JavaScript库处理字符串ID更稳定
        node.put("id", id.toString());
        node.put("name", name);
        node.put("category", category); // 用于图例分类

        // 为了让图谱视觉上更好看，为不同类型的节点分配不同的大小
        int symbolSize = 20; // 默认大小
        if ("方剂".equals(category)) {
            symbolSize = 40;
        } else if ("疾病".equals(category) || "证候".equals(category)) {
            symbolSize = 30;
        } else if ("药材".equals(category)) {
            symbolSize = 25;
        }
        node.put("symbolSize", symbolSize);

        return node;
    }
    private Map<String, Object> createLink(Long sourceId, Long targetId, String label) {
        Map<String, Object> link = new HashMap<>();
        link.put("source", sourceId.toString());
        link.put("target", targetId.toString());

        // **【核心修改】**：直接将label作为顶层属性
        if (label != null && !label.isBlank()) {
            link.put("label", label);
        }

        return link;
    }
}