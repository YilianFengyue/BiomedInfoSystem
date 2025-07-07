package org.csu.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.csu.dto.PaperQueryDTO;
import org.csu.dto.PaperVO;

public interface IResearchService {
    Page<PaperVO> searchPapers(PaperQueryDTO query, Integer page, Integer size);
} 