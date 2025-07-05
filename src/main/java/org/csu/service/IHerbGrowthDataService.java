package org.csu.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.csu.domain.HerbGrowthData;
import com.baomidou.mybatisplus.extension.service.IService;
import org.csu.domain.HerbGrowthDataHistory;
import org.csu.dto.HerbGrowthDataHistoryDto;

import java.util.List;

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


    /**
     * 【新增】根据观测点ID获取其所有相关的生长数据变更历史
     * @param locationId 观测点ID
     * @return 历史记录列表
     */
    /**
     * 【修改】根据观测点ID获取其所有相关的生长数据变更历史，并附带药材名和地址
     * @param locationId 观测点ID
     * @return 增强后的历史记录列表
     */
    List<HerbGrowthDataHistoryDto> getHistoryByLocationId(Long locationId);

    /**
     * 【新增】获取所有生长数据变更历史，并附带药材名和地址详情
     * @param queryWrapper 查询条件
     * @return 增强后的历史记录列表
     */
    List<HerbGrowthDataHistoryDto> getAllHistoryWithDetails(QueryWrapper<HerbGrowthDataHistory> queryWrapper);

    // 【新增方法】创建一个新的方法，专门用于保存数据并记录"CREATE"类型的历史
    void createGrowthDataAndLogHistory(HerbGrowthData growthData, String uploaderName);
}
