package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.csu.dao.ResearchAchievementDao;
import org.csu.domain.ResearchAchievement;
import org.csu.dto.PaperQueryDTO;
import org.csu.dto.PaperVO;
import org.csu.service.IResearchService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.stream.Collectors;

@Service
public class ResearchServiceImpl implements IResearchService {

    private static final String ACHIEVEMENT_TYPE_PAPER = "论文";

    @Autowired
    private ResearchAchievementDao researchAchievementDao;

    @Override
    public Page<PaperVO> searchPapers(PaperQueryDTO query, Integer page, Integer size) {
        Page<ResearchAchievement> achievementPage = new Page<>(page, size);
        LambdaQueryWrapper<ResearchAchievement> wrapper = new LambdaQueryWrapper<>();

        // Base filter: only search for papers
        wrapper.eq(ResearchAchievement::getAchievementType, ACHIEVEMENT_TYPE_PAPER);

        // Keyword search across multiple fields
        if (StringUtils.hasText(query.getKeyword())) {
            wrapper.and(w -> w.like(ResearchAchievement::getTitle, query.getKeyword())
                    .or().like(ResearchAchievement::getAuthors, query.getKeyword())
                    .or().like(ResearchAchievement::getKeywords, query.getKeyword())
                    .or().like(ResearchAchievement::getAbstractText, query.getKeyword()));
        }

        // Specific field search
        wrapper.like(StringUtils.hasText(query.getAuthor()), ResearchAchievement::getAuthors, query.getAuthor());
        wrapper.like(StringUtils.hasText(query.getPublication()), ResearchAchievement::getPublication, query.getPublication());

        // Execute query
        Page<ResearchAchievement> resultPage = researchAchievementDao.selectPage(achievementPage, wrapper);

        // Convert to VO
        Page<PaperVO> voPage = new Page<>();
        BeanUtils.copyProperties(resultPage, voPage, "records");
        voPage.setRecords(resultPage.getRecords().stream().map(item -> {
            PaperVO vo = new PaperVO();
            BeanUtils.copyProperties(item, vo);
            return vo;
        }).collect(Collectors.toList()));

        return voPage;
    }
} 