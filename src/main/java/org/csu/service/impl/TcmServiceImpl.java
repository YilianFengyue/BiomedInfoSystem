package org.csu.service.impl;

import org.csu.domain.node.*;
import org.csu.domain.relationship.HerbComponent;
import org.csu.config.ResourceNotFoundException;
import org.csu.repository.*;
import org.csu.service.TcmService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.Optional;

@Service
public class TcmServiceImpl implements TcmService {

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

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getGraphDataForFormula(String name) {
        FormulaNode formula = formulaRepository.findByName(name)
                .orElseThrow(() -> new ResourceNotFoundException("未找到方剂: " + name));

        Set<Map<String, Object>> nodes = new HashSet<>();
        Set<Map<String, Object>> links = new HashSet<>();

        nodes.add(createNode(formula.getId(), formula.getName(), "方剂", formula.getDescription()));

        if (formula.getHerbComponents() != null) {
            formula.getHerbComponents().forEach(comp -> {
                HerbNode herb = comp.getHerb();
                if (herb != null) {
                    nodes.add(createNode(herb.getId(), herb.getName(), "药材", herb.getDescription()));
                    links.add(createLink(formula.getId(), herb.getId(), "包含 " + comp.getDosage()));
                }
            });
        }
        if (formula.getTreatedDiseases() != null) {
            formula.getTreatedDiseases().forEach(d -> {
                nodes.add(createNode(d.getId(), d.getName(), "疾病", d.getDescription()));
                links.add(createLink(formula.getId(), d.getId(), "治疗"));
            });
        }
        if (formula.getTreatedSyndromes() != null) {
            formula.getTreatedSyndromes().forEach(s -> {
                nodes.add(createNode(s.getId(), s.getName(), "证候", s.getDescription()));
                links.add(createLink(formula.getId(), s.getId(), "主治"));
            });
        }
        return Map.of("nodes", nodes, "links", links);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getGraphDataForDisease(String name) {
        DiseaseNode disease = diseaseRepository.findByName(name)
                .orElseThrow(() -> new ResourceNotFoundException("未找到疾病: " + name));

        Set<Map<String, Object>> nodes = new HashSet<>();
        Set<Map<String, Object>> links = new HashSet<>();

        nodes.add(createNode(disease.getId(), disease.getName(), "疾病", disease.getDescription()));

        if (disease.getSymptoms() != null) disease.getSymptoms().forEach(s -> {
            nodes.add(createNode(s.getId(), s.getName(), "症状", s.getDescription()));
            links.add(createLink(disease.getId(), s.getId(), "表现为"));
        });
        if (disease.getSyndromes() != null) disease.getSyndromes().forEach(s -> {
            nodes.add(createNode(s.getId(), s.getName(), "证候", s.getDescription()));
            links.add(createLink(disease.getId(), s.getId(), "包含"));
        });

        formulaRepository.findByTreatedDiseasesName(name).forEach(f -> {
            nodes.add(createNode(f.getId(), f.getName(), "方剂", f.getDescription()));
            links.add(createLink(f.getId(), disease.getId(), "治疗"));
        });

        return Map.of("nodes", nodes, "links", links);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getGraphDataForHerb(String name) {
        HerbNode herb = herbRepository.findByName(name)
                .orElseThrow(() -> new ResourceNotFoundException("未找到药材: " + name));
        Set<Map<String, Object>> nodes = new HashSet<>();
        Set<Map<String, Object>> links = new HashSet<>();
        nodes.add(createNode(herb.getId(), herb.getName(), "药材", herb.getDescription()));

        // 【修正】: 使用正确的方法名 findByHerbName
        formulaRepository.findByHerbName(name).forEach(f -> {
            nodes.add(createNode(f.getId(), f.getName(), "方剂", f.getDescription()));
            links.add(createLink(f.getId(), herb.getId(), "包含于"));
        });
        return Map.of("nodes", nodes, "links", links);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getGraphDataForSymptom(String name) {
        SymptomNode symptom = symptomRepository.findByName(name)
                .orElseThrow(() -> new ResourceNotFoundException("未找到症状: " + name));
        Set<Map<String, Object>> nodes = new HashSet<>();
        Set<Map<String, Object>> links = new HashSet<>();
        nodes.add(createNode(symptom.getId(), symptom.getName(), "症状", symptom.getDescription()));
        diseaseRepository.findBySymptomsName(name).forEach(d -> {
            nodes.add(createNode(d.getId(), d.getName(), "疾病", d.getDescription()));
            links.add(createLink(d.getId(), symptom.getId(), "表现为"));
        });
        return Map.of("nodes", nodes, "links", links);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getGraphDataForSyndrome(String name) {
        SyndromeNode syndrome = syndromeRepository.findByName(name)
                .orElseThrow(() -> new ResourceNotFoundException("未找到证候: " + name));
        Set<Map<String, Object>> nodes = new HashSet<>();
        Set<Map<String, Object>> links = new HashSet<>();
        nodes.add(createNode(syndrome.getId(), syndrome.getName(), "证候", syndrome.getDescription()));
        formulaRepository.findByTreatedSyndromesName(name).forEach(f -> {
            nodes.add(createNode(f.getId(), f.getName(), "方剂", f.getDescription()));
            links.add(createLink(f.getId(), syndrome.getId(), "治疗"));
        });
        diseaseRepository.findBySyndromesName(name).forEach(d -> {
            nodes.add(createNode(d.getId(), d.getName(), "疾病", d.getDescription()));
            links.add(createLink(d.getId(), syndrome.getId(), "包含"));
        });
        return Map.of("nodes", nodes, "links", links);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getGraphDataForMeridian(String name) {
        MeridianNode meridian = meridianRepository.findByName(name)
                .orElseThrow(() -> new ResourceNotFoundException("未找到经络: " + name));
        Set<Map<String, Object>> nodes = new HashSet<>();
        Set<Map<String, Object>> links = new HashSet<>();
        nodes.add(createNode(meridian.getId(), meridian.getName(), "经络", meridian.getName()));

        herbRepository.findByMeridiansName(name).forEach(h -> {
            nodes.add(createNode(h.getId(), h.getName(), "药材", h.getDescription()));
            links.add(createLink(h.getId(), meridian.getId(), "归经于"));
        });

        if(meridian.getAcupoints() != null) {
            meridian.getAcupoints().forEach(a -> {
                nodes.add(createNode(a.getId(), a.getName(), "穴位", a.getName()));
                links.add(createLink(meridian.getId(), a.getId(), "包含"));
            });
        }
        return Map.of("nodes", nodes, "links", links);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getGraphDataForAcupoint(String name) {
        AcupointNode acupoint = acupointRepository.findByName(name)
                .orElseThrow(() -> new ResourceNotFoundException("未找到穴位: " + name));
        Set<Map<String, Object>> nodes = new HashSet<>();
        Set<Map<String, Object>> links = new HashSet<>();
        nodes.add(createNode(acupoint.getId(), acupoint.getName(), "穴位", acupoint.getName()));
        meridianRepository.findByAcupointsName(name).forEach(m -> {
            nodes.add(createNode(m.getId(), m.getName(), "经络", m.getName()));
            links.add(createLink(m.getId(), acupoint.getId(), "包含"));
        });
        return Map.of("nodes", nodes, "links", links);
    }

    private Map<String, Object> createNode(Long id, String name, String category, String description) {
        Map<String, Object> node = new HashMap<>();
        node.put("id", id.toString());
        node.put("name", name);
        node.put("category", category);
        node.put("description", description);
        int symbolSize = 20;
        if ("方剂".equals(category)) { symbolSize = 40; }
        else if ("疾病".equals(category) || "证候".equals(category)) { symbolSize = 30; }
        else if ("药材".equals(category)) { symbolSize = 25; }
        node.put("symbolSize", symbolSize);
        return node;
    }

    private Map<String, Object> createLink(Long sourceId, Long targetId, String label) {
        Map<String, Object> link = new HashMap<>();
        link.put("source", sourceId.toString());
        link.put("target", targetId.toString());
        if (label != null && !label.isBlank()) {
            link.put("label", label);
        }
        return link;
    }
}