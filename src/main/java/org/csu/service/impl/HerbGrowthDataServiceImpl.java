package org.csu.service.impl;

import org.csu.dao.HerbGrowthDataHistoryDao;
import org.csu.domain.HerbGrowthData;
import org.csu.dao.HerbGrowthDataDao;
import org.csu.domain.HerbGrowthDataHistory;
import org.csu.service.IHerbGrowthDataService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.csu.util.ThreadLocalUtil;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Map;

/**
 * <p>
 * 生长/统计数据表 服务实现类
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Service
public class HerbGrowthDataServiceImpl extends ServiceImpl<HerbGrowthDataDao, HerbGrowthData> implements IHerbGrowthDataService {

    @Autowired
    private HerbGrowthDataHistoryDao historyDao;

    @Override
    @Transactional
    public boolean updateGrowthDataAndLogHistory(HerbGrowthData updatedGrowthData) {
        // 1. 根据ID查询旧的生长数据
        HerbGrowthData oldGrowthData = this.getById(updatedGrowthData.getId());
        if (oldGrowthData == null) {
            // 如果找不到数据，无法继续，可以抛出异常或返回false
            return false;
        }

        // 2. 创建历史记录对象
        HerbGrowthDataHistory history = new HerbGrowthDataHistory();
        history.setOriginId(oldGrowthData.getId());
        history.setLocationId(oldGrowthData.getLocationId());
        history.setMetricName(oldGrowthData.getMetricName());
        history.setOldValue(oldGrowthData.getMetricValue());
        history.setNewValue(updatedGrowthData.getMetricValue());
        history.setAction("UPDATE");
        history.setChangedAt(LocalDateTime.now());

        // 尝试从ThreadLocal获取操作人信息
        Map<String, Object> claims = ThreadLocalUtil.getThreadLocal();
        if (claims != null && claims.containsKey("username")) {
            history.setChangedBy((String) claims.get("username"));
        } else {
            history.setChangedBy("SYSTEM"); // or a default value
        }

        // 3. 保存历史记录
        historyDao.insert(history);

        // 4. 更新原数据
        // 使用BeanUtils复制可更新的字段，避免覆盖主键等
        // 注意：这里假设前端传来的updatedGrowthData包含了所有需要更新的字段
        BeanUtils.copyProperties(updatedGrowthData, oldGrowthData, "id", "locationId", "recordedAt");
        oldGrowthData.setRecordedAt(LocalDateTime.now()); // 更新记录时间

        return this.updateById(oldGrowthData);
    }
}
