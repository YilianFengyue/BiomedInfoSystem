package org.csu.service;

import org.csu.domain.HerbGrowthData;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 * 生长/统计数据表 服务类
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
public interface IHerbGrowthDataService extends IService<HerbGrowthData> {
    /**
     * 更新生长数据并记录历史
     *
     * @param growthData 要更新的数据
     * @return 是否成功
     */
    boolean updateGrowthDataAndLogHistory(HerbGrowthData growthData);
}
