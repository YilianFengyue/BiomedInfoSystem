package org.csu.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.csu.dto.PaperQueryDTO;
import org.csu.dto.PaperVO;
import org.csu.service.IResearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/research")
public class ResearchController {

    @Autowired
    private IResearchService researchService;

    @GetMapping("/papers")
    public Result<Page<PaperVO>> searchPapers(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            PaperQueryDTO query) {
        Page<PaperVO> result = researchService.searchPapers(query, page, size);
        return Result.success(result);
    }
} 