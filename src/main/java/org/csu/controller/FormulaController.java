package org.csu.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.csu.dto.*;
import org.csu.service.IFormulaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/formula")
public class FormulaController {

    @Autowired
    private IFormulaService formulaService;

    @GetMapping("/page")
    public Result<Page<FormulaVO>> getFormulaPage(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer categoryId,
            @RequestParam(required = false) String source) {

        FormulaQueryDTO query = new FormulaQueryDTO();
        query.setKeyword(keyword);
        query.setCategoryId(categoryId);
        query.setSource(source);

        Page<FormulaVO> result = formulaService.getFormulaPage(page, size, query);
        return Result.success(result);
    }

    @GetMapping("/{id}")
    public Result<FormulaDetailVO> getFormulaDetail(@PathVariable Long id) {
        FormulaDetailVO detail = formulaService.getFormulaDetail(id);
        return Result.success(detail);
    }

    @PostMapping("/recommend")
    public Result<List<FormulaRecommendVO>> recommendFormula(
            @RequestBody SymptomAnalysisDTO symptoms) {
        List<FormulaRecommendVO> recommendations = formulaService.recommendBySymptoms(symptoms);
        return Result.success(recommendations);
    }

    @GetMapping("/analysis/herb-combinations")
    public Result<List<HerbCombinationVO>> analyzeHerbCombinations(
            @RequestParam String herbName) {
        List<HerbCombinationVO> combinations = formulaService.analyzeHerbCombinations(herbName);
        return Result.success(combinations);
    }

    @PostMapping("/compare")
    public Result<FormulaComparisonVO> compareFormulas(
            @RequestBody List<Long> formulaIds) {
        FormulaComparisonVO comparison = formulaService.compareFormulas(formulaIds);
        return Result.success(comparison);
    }
} 