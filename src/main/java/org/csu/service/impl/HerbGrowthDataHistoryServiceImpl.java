package org.csu.service.impl;

import org.csu.domain.HerbGrowthDataHistory;
import org.csu.dao.HerbGrowthDataHistoryDao;
import org.csu.service.IHerbGrowthDataHistoryService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 生长/统计数据变更历史表 服务实现类
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Service
public class HerbGrowthDataHistoryServiceImpl extends ServiceImpl<HerbGrowthDataHistoryDao, HerbGrowthDataHistory> implements IHerbGrowthDataHistoryService {

}
