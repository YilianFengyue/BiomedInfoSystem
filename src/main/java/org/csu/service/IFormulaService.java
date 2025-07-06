package org.csu.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.csu.dto.*;

import java.util.List;

public interface IFormulaService {
    Page<FormulaVO> getFormulaPage(Integer page, Integer size, FormulaQueryDTO query);

    FormulaDetailVO getFormulaDetail(Long id);

    List<FormulaRecommendVO> recommendBySymptoms(SymptomAnalysisDTO symptoms);

    List<HerbCombinationVO> analyzeHerbCombinations(String herbName);

    FormulaComparisonVO compareFormulas(List<Long> formulaIds);
} 