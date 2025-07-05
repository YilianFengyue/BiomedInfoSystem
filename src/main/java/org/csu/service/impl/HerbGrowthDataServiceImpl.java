package org.csu.service.impl;

import java.util.Collections;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.csu.dao.HerbGrowthDataHistoryDao;
import org.csu.domain.Herb;
import org.csu.domain.HerbGrowthData;
import org.csu.dao.HerbGrowthDataDao;
import org.csu.domain.HerbGrowthDataHistory;
import org.csu.domain.HerbLocation;
import org.csu.dto.HerbGrowthDataHistoryDto;
import org.csu.service.IHerbGrowthDataHistoryService;
import org.csu.service.IHerbGrowthDataService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.csu.service.IHerbLocationService;
import org.csu.service.IHerbService;
import org.csu.util.ThreadLocalUtil;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

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
    private IHerbGrowthDataHistoryService historyService; // 确保历史服务已注入


    @Autowired
    private HerbGrowthDataHistoryDao historyDao;

    @Autowired
    private HerbGrowthDataHistoryDao historyMapper;

    @Autowired
    private IHerbLocationService locationService; // 注入Location服务

    @Autowired
    private IHerbService herbService; // 注入Herb服务

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

    /**
     * 【修改】实现数据聚合逻辑
     */
    @Override
    public List<HerbGrowthDataHistoryDto> getHistoryByLocationId(Long locationId) {

        // 1. 获取基础历史数据
        QueryWrapper<HerbGrowthDataHistory> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("location_id", locationId).orderByDesc("changed_at");
        List<HerbGrowthDataHistory> histories = historyMapper.selectList(queryWrapper);

        if (histories.isEmpty()) {
            return java.util.Collections.emptyList();
        }

        // 2. 获取关联的地点和药材信息
        HerbLocation location = locationService.getById(locationId);
        if (location == null) {
            return java.util.Collections.emptyList(); // 如果地点不存在，直接返回
        }
        Herb herb = herbService.getById(location.getHerbId());

        // 3. 组装DTO列表
        return histories.stream().map(history -> {
            HerbGrowthDataHistoryDto dto = new HerbGrowthDataHistoryDto();
            BeanUtils.copyProperties(history, dto); // 复制基础属性
            if (herb != null) {
                dto.setHerbName(herb.getName()); // 设置药材名
            }
            dto.setAddress(location.getAddress()); // 设置地址
            return dto;
        }).collect(Collectors.toList());
    }

    @Override
    public List<HerbGrowthDataHistoryDto> getAllHistoryWithDetails(QueryWrapper<HerbGrowthDataHistory> queryWrapper) {
        // 1. 根据传入的条件查询基础历史数据
        List<HerbGrowthDataHistory> histories = historyMapper.selectList(queryWrapper);

        if (histories.isEmpty()) {
            return java.util.Collections.emptyList();
        }

        // 2. 批量获取所有涉及的 locationIds 和 herbIds
        List<Long> locationIds = histories.stream().map(HerbGrowthDataHistory::getLocationId).distinct().collect(Collectors.toList());
        List<HerbLocation> locations = locationService.listByIds(locationIds);
        Map<Long, HerbLocation> locationMap = locations.stream().collect(Collectors.toMap(HerbLocation::getId, Function.identity()));

        List<Long> herbIds = locations.stream().map(HerbLocation::getHerbId).distinct().collect(Collectors.toList());

        //  关键修复：如果 herbIds 为空，则 herbMap 也为空，避免无效查询
        Map<Long, Herb> herbMap;
        if (herbIds.isEmpty()) {
            herbMap = Collections.emptyMap();
        } else {
            herbMap = herbService.listByIds(herbIds).stream().collect(Collectors.toMap(Herb::getId, Function.identity()));
        }

        // 3. 组装最终的DTO列表
        return histories.stream().map(history -> {
            HerbGrowthDataHistoryDto dto = new HerbGrowthDataHistoryDto();
            BeanUtils.copyProperties(history, dto); // 复制基础属性

            HerbLocation location = locationMap.get(history.getLocationId());
            if (location != null) {
                dto.setAddress(location.getAddress()); // 设置地址
                Herb herb = herbMap.get(location.getHerbId());
                if (herb != null) {
                    dto.setHerbName(herb.getName()); // 设置药材名
                }
            }
            return dto;
        }).collect(Collectors.toList());
    }

    /**
     * 【实现新增历史Create的方法】
     * 1. 保存主数据
     * 2. 创建一条对应的历史记录
     */
    @Override
    @Transactional // 建议添加事务注解，确保两个操作要么都成功，要么都失败
    public void createGrowthDataAndLogHistory(HerbGrowthData growthData, String uploaderName) {
        // 1. 保存主数据到 herb_growth_data 表
        this.save(growthData); // growthData在保存后，其ID会被自动填充

        // 2. 创建并保存历史记录到 herb_growth_data_history 表
        HerbGrowthDataHistory history = new HerbGrowthDataHistory();
        history.setOriginId(growthData.getId()); // 关联到刚刚创建的主数据ID
        history.setLocationId(growthData.getLocationId());
        history.setMetricName(growthData.getMetricName());
        history.setOldValue(null); // 创建操作没有旧值
        history.setNewValue(growthData.getMetricValue() + " " + growthData.getMetricUnit());
        history.setAction("CREATE"); // 操作类型为创建
        history.setChangedBy(uploaderName); // 使用传入的上传者姓名
        history.setChangedAt(LocalDateTime.now()); // 记录当前时间
        history.setRemark("用户初次上传数据");

        historyService.save(history);
    }

}
