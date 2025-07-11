package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.csu.dao.FormulaDao;
import org.csu.dao.FormulaHerbDao;
import org.csu.domain.Formula;
import org.csu.domain.FormulaHerb;
import org.csu.dto.*;
import org.csu.service.IFormulaService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.LinkedHashMap;

@Service
public class FormulaServiceImpl implements IFormulaService {

    @Autowired
    private FormulaDao formulaDao;

    @Autowired
    private FormulaHerbDao formulaHerbDao;

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
        // 1. 查找所有包含目标药材的方剂ID
        LambdaQueryWrapper<FormulaHerb> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(FormulaHerb::getHerbName, herbName)
                    .select(FormulaHerb::getFormulaId);

        List<Long> formulaIds = formulaHerbDao.selectList(queryWrapper).stream()
                .map(FormulaHerb::getFormulaId)
                .distinct()
                .collect(Collectors.toList());

        if (formulaIds.isEmpty()) {
            return Collections.emptyList();
        }

        // 2. 查找这些方剂中的所有药材
        LambdaQueryWrapper<FormulaHerb> coOccurrenceWrapper = new LambdaQueryWrapper<>();
        coOccurrenceWrapper.in(FormulaHerb::getFormulaId, formulaIds);
        List<FormulaHerb> allRelatedHerbs = formulaHerbDao.selectList(coOccurrenceWrapper);

        // 3. 排除目标药材自身，并统计其他药材的出现频率
        Map<String, Long> frequencyMap = allRelatedHerbs.stream()
                .map(FormulaHerb::getHerbName)
                .filter(name -> !name.equals(herbName))
                .collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));

        // 4. 计算配伍比例并封装成VO
        long totalFormulasWithHerb = formulaIds.size();
        return frequencyMap.entrySet().stream()
                .map(entry -> {
                    HerbCombinationVO vo = new HerbCombinationVO();
                    vo.setHerbName(entry.getKey());
                    vo.setCombinationCount(entry.getValue());
                    // 配伍比例 = 出现次数 / 包含目标药材的总方剂数
                    vo.setCombinationRatio((double) entry.getValue() / totalFormulasWithHerb);
                    return vo;
                })
                .sorted((v1, v2) -> Long.compare(v2.getCombinationCount(), v1.getCombinationCount()))
                .collect(Collectors.toList());
    }

    @Override
    public FormulaComparisonVO compareFormulas(List<Long> formulaIds) {
        if (formulaIds == null || formulaIds.size() < 2) {
            // Can't compare less than 2 formulas
            return new FormulaComparisonVO();
        }

        // 1. Fetch details for all formulas
        List<Formula> formulas = formulaDao.selectBatchIds(formulaIds);
        List<FormulaDetailVO> formulaDetails = formulas.stream()
                .map(formula -> {
                    FormulaDetailVO vo = new FormulaDetailVO();
                    BeanUtils.copyProperties(formula, vo);
                    return vo;
                }).collect(Collectors.toList());

        // 2. Create comparison map
        Map<String, List<String>> comparisonPoints = new LinkedHashMap<>(); // Use LinkedHashMap to maintain order

        comparisonPoints.put("方剂名称", formulas.stream().map(Formula::getName).collect(Collectors.toList()));
        comparisonPoints.put("出处", formulas.stream().map(Formula::getSource).collect(Collectors.toList()));
        comparisonPoints.put("功用", formulas.stream().map(Formula::getFunctionEffect).collect(Collectors.toList()));
        comparisonPoints.put("主治", formulas.stream().map(Formula::getMainTreatment).collect(Collectors.toList()));
        comparisonPoints.put("药物组成", formulas.stream().map(Formula::getComposition).collect(Collectors.toList()));


        // 3. Build the final VO
        FormulaComparisonVO result = new FormulaComparisonVO();
        result.setFormulas(formulaDetails);
        result.setComparisonPoints(comparisonPoints);

        return result;
    }
} 