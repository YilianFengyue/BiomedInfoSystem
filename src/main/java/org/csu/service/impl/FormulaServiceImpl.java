package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.csu.dao.FormulaDao;
import org.csu.domain.Formula;
import org.csu.dto.*;
import org.csu.service.IFormulaService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class FormulaServiceImpl implements IFormulaService {

    @Autowired
    private FormulaDao formulaDao;

    // @Autowired
    // private KnowledgeGraphService knowledgeGraphService;

    @Override
    public Page<FormulaVO> getFormulaPage(Integer page, Integer size, FormulaQueryDTO query) {
        Page<Formula> formulaPage = new Page<>(page, size);
        LambdaQueryWrapper<Formula> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StringUtils.hasText(query.getKeyword()), Formula::getName, query.getKeyword())
                .or()
                .like(StringUtils.hasText(query.getKeyword()), Formula::getMainTreatment, query.getKeyword());
        wrapper.eq(query.getCategoryId() != null, Formula::getCategoryId, query.getCategoryId());
        wrapper.like(StringUtils.hasText(query.getSource()), Formula::getSource, query.getSource());
        
        Page<Formula> resultPage = formulaDao.selectPage(formulaPage, wrapper);
        
        Page<FormulaVO> voPage = new Page<>();
        BeanUtils.copyProperties(resultPage, voPage, "records");
        
        List<FormulaVO> voList = resultPage.getRecords().stream().map(item -> {
            FormulaVO vo = new FormulaVO();
            BeanUtils.copyProperties(item, vo);
            return vo;
        }).collect(Collectors.toList());
        
        voPage.setRecords(voList);
        return voPage;
    }

    @Override
    public FormulaDetailVO getFormulaDetail(Long id) {
        Formula formula = formulaDao.selectById(id);
        if (formula == null) {
            return null;
        }
        FormulaDetailVO vo = new FormulaDetailVO();
        BeanUtils.copyProperties(formula, vo);
        // Here you can add logic to fetch related data like herbs, cases, etc.
        return vo;
    }

    @Override
    public List<FormulaRecommendVO> recommendBySymptoms(SymptomAnalysisDTO symptoms) {
        // 1. 症状向量化 (Simplified)
        List<String> symptomList = symptoms.getSymptoms();
        if (symptomList == null || symptomList.isEmpty()) {
            return Collections.emptyList();
        }

        // 2. 相似度计算 (This needs a custom query in Mapper)
        // List<Formula> candidateFormulas = formulaDao.findBySymptoms(symptomList);
        // For now, using a simple search
        LambdaQueryWrapper<Formula> wrapper = new LambdaQueryWrapper<>();
        symptomList.forEach(symptom -> wrapper.or().like(Formula::getMainTreatment, symptom));
        List<Formula> candidateFormulas = formulaDao.selectList(wrapper);


        // 3. 评分排序
        return candidateFormulas.stream()
                .map(this::calculateRecommendScore)
                .sorted((a, b) -> Double.compare(b.getScore(), a.getScore()))
                .limit(10)
                .collect(Collectors.toList());
    }

    private FormulaRecommendVO calculateRecommendScore(Formula formula) {
        // Placeholder for recommendation score calculation
        double score = 0.0;
        score += calculateSymptomMatch(formula) * 0.4;
        score += calculateUsageFrequency(formula) * 0.25;
        score += calculateEfficacyScore(formula) * 0.25;
        score += calculateSafetyScore(formula) * 0.1;

        return FormulaRecommendVO.builder()
                .formulaId(formula.getId())
                .formulaName(formula.getName())
                .score(score)
                .matchedSymptoms(getMatchedSymptoms(formula))
                .recommendation(generateRecommendation(formula, score))
                .build();
    }
    
    // Placeholder methods for scoring
    private double calculateSymptomMatch(Formula formula) { return Math.random(); }
    private double calculateUsageFrequency(Formula formula) { return Math.random(); }
    private double calculateEfficacyScore(Formula formula) { return Math.random(); }
    private double calculateSafetyScore(Formula formula) { return Math.random(); }
    private List<String> getMatchedSymptoms(Formula formula) { return Collections.singletonList("sample symptom"); }
    private String generateRecommendation(Formula formula, double score) { return "Recommended based on score: " + String.format("%.2f", score); }


    @Override
    public List<HerbCombinationVO> analyzeHerbCombinations(String herbName) {
        // Placeholder implementation
        return Collections.emptyList();
    }

    @Override
    public FormulaComparisonVO compareFormulas(List<Long> formulaIds) {
        // Placeholder implementation
        return new FormulaComparisonVO();
    }
} 