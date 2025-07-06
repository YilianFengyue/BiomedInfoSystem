package org.csu.service.impl;

import org.csu.dao.*;
import org.csu.domain.*;
import org.csu.dto.HerbDistributionDto;
import org.csu.dto.HerbGrowthDataDto;
import org.csu.dto.HerbUploadDetailDto;
import org.csu.dto.HerbUploadDto;
import org.csu.service.IHerbService;
import org.csu.config.BusinessException;
import org.csu.config.SystemException;
import org.csu.controller.Code;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.logging.log4j.util.Strings;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;
import java.util.Map;

/**
 * <p>
 * 药材主信息表 服务实现类
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Service
@Slf4j
public class HerbServiceImpl extends ServiceImpl<HerbDao, Herb> implements IHerbService {
    
    @Autowired
    private HerbLocationDao herbLocationDao;
    
    @Autowired
    private HerbGrowthDataDao herbGrowthDataDao;

    @Autowired
    private HerbImageDao herbImageDao;
    @Autowired
    private HerbGrowthDataHistoryDao historyDao;
    
    // ServiceImpl 已经自动注入了 baseMapper (即 HerbDao)，可以直接使用
    @Override
    public boolean createHerb(Herb herb) {
        try {
            // 参数校验
            if (herb == null || !StringUtils.hasText(herb.getName())) {
                throw new BusinessException(Code.VALIDATE_ERR, "药材名称不能为空");
            }
            
            // 使用 Mybatis-Plus 自带的 save 方法，插入成功会返回 true
            boolean result = save(herb);
            if (!result) {
                throw new BusinessException(Code.SAVE_ERR, "药材信息保存失败");
            }
            return result;
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new SystemException(Code.SYSTEM_ERR, "系统异常，药材信息保存失败", e);
        }
    }

    @Override
    public boolean deleteHerbById(Long id) {
        try {
            // 参数校验
            if (id == null || id <= 0) {
                throw new BusinessException(Code.VALIDATE_ERR, "药材ID不能为空且必须大于0");
            }
            
            // 检查药材是否存在
            Herb herb = baseMapper.selectById(id);
            if (herb == null) {
                throw new BusinessException(Code.DELETE_ERR, "要删除的药材不存在");
            }
            
            // 使用 Mybatis-Plus 自带的 removeById 方法
            int rows = baseMapper.deleteById(id);
            return rows > 0;
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new SystemException(Code.SYSTEM_ERR, "系统异常，药材删除失败", e);
        }
    }

    @Override
    public boolean updateHerb(Herb herb) {
        try {
            // 参数校验
            if (herb == null || herb.getId() == null) {
                throw new BusinessException(Code.VALIDATE_ERR, "药材ID不能为空");
            }
            if (!StringUtils.hasText(herb.getName())) {
                throw new BusinessException(Code.VALIDATE_ERR, "药材名称不能为空");
            }
            
            // 检查药材是否存在
            Herb existingHerb = baseMapper.selectById(herb.getId());
            if (existingHerb == null) {
                throw new BusinessException(Code.UPDATE_ERR, "要更新的药材不存在");
            }
            
            // 使用 Mybatis-Plus 自带的 updateById 方法
            int rows = baseMapper.updateById(herb);
            return rows > 0;
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new SystemException(Code.SYSTEM_ERR, "系统异常，药材更新失败", e);
        }
    }

    @Override
    public Herb getHerbById(Long id) {
        try {
            // 参数校验
            if (id == null || id <= 0) {
                throw new BusinessException(Code.VALIDATE_ERR, "药材ID不能为空且必须大于0");
            }
            
            Herb herb = baseMapper.selectById(id);
            if (herb == null) {
                throw new BusinessException(Code.GET_ERR, "指定的药材不存在");
            }
            
            return herb;
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new SystemException(Code.SYSTEM_ERR, "系统异常，查询药材失败", e);
        }
    }

    @Override
    public List<Herb> getAllHerbs() {
        try {
            // selectList(null) 表示查询所有
            return baseMapper.selectList(null);
        } catch (Exception e) {
            throw new SystemException(Code.SYSTEM_ERR, "系统异常，查询药材列表失败", e);
        }
    }

    @Override
    public List<HerbDistributionDto> getHerbDistribution(String province) {
        try {
            // 使用 MyBatis-Plus 构建查询条件
            QueryWrapper<HerbLocation> queryWrapper = new QueryWrapper<>();
            
            // 如果指定了省份，使用模糊查询以提高匹配率（例如 "四川" 能匹配 "四川省"）
            if (StringUtils.hasText(province)) {
                queryWrapper.like("province", province);
            }
            
            // 按省份和城市排序
            queryWrapper.orderByAsc("province", "city");
            
            // 查询观测点列表
            List<HerbLocation> locations = herbLocationDao.selectList(queryWrapper);
            
            // 如果没有查询到数据，返回空列表（这是正常情况，不抛异常）
            if (locations == null || locations.isEmpty()) {
                log.info("未查询到药材分布数据，province={}", province);
                return List.of(); // 返回空列表而不是null
            }
            
            // 转换为DTO对象
            List<HerbDistributionDto> result = locations.stream().map(location -> {
                try {
                    // 获取对应的药材信息
                    Herb herb = baseMapper.selectById(location.getHerbId());
                    if (herb == null) {
                        // 记录数据不一致问题，但不中断整个查询
                        log.warn("观测点{}关联的药材{}不存在", location.getId(), location.getHerbId());
                        return null;
                    }
                    
                    // 构建DTO对象
                    HerbDistributionDto dto = new HerbDistributionDto();
                    dto.setLocationId(location.getId());
                    dto.setHerbId(herb.getId());
                    dto.setHerbName(herb.getName());
                    dto.setAddress(location.getAddress());
                    dto.setLongitude(location.getLongitude());
                    dto.setLatitude(location.getLatitude());
                    dto.setProvince(location.getProvince());
                    dto.setCity(location.getCity());
                    dto.setObservationYear(location.getObservationYear());
                    
                    return dto;
                } catch (Exception e) {
                    log.error("处理观测点{}数据时发生异常", location.getId(), e);
                    return null;
                }
            }).filter(dto -> dto != null)  // 过滤掉空值
              .collect(Collectors.toList());
              
            log.info("成功查询到{}条药材分布数据，province={}", result.size(), province);
            return result;
              
        } catch (Exception e) {
            throw new SystemException(Code.SYSTEM_ERR, "系统异常，查询药材分布数据失败", e);
        }
    }

    @Override
    public List<HerbGrowthDataDto> getGrowthDataForHerb(Long herbId) {
        try {
            // 1. 参数校验
            if (herbId == null || herbId <= 0) {
                throw new BusinessException(Code.VALIDATE_ERR, "药材ID无效");
            }
            // 检查药材是否存在
            if (baseMapper.selectById(herbId) == null) {
                throw new BusinessException(Code.GET_ERR, "指定的药材不存在");
            }

            // 2. 根据药材ID查询其所有的观测点
            QueryWrapper<HerbLocation> locationQuery = new QueryWrapper<>();
            locationQuery.eq("herb_id", herbId);
            List<HerbLocation> locations = herbLocationDao.selectList(locationQuery);

            if (locations.isEmpty()) {
                log.info("药材ID {} 没有关联的观测点", herbId);
                return List.of();
            }

            // 3. 提取所有观测点ID，并创建一个从ID到观测点信息的映射
            List<Long> locationIds = locations.stream().map(HerbLocation::getId).collect(Collectors.toList());
            Map<Long, HerbLocation> locationMap = locations.stream()
                    .collect(Collectors.toMap(HerbLocation::getId, location -> location));

            // 4. 根据观测点ID列表查询所有相关的生长数据
            QueryWrapper<HerbGrowthData> growthDataQuery = new QueryWrapper<>();
            growthDataQuery.in("location_id", locationIds)
                           .orderByAsc("recorded_at"); // 按记录时间排序
            List<HerbGrowthData> growthDataList = herbGrowthDataDao.selectList(growthDataQuery);

            // 5. 将生长数据(HerbGrowthData)和位置信息(HerbLocation)组装成DTO
            return growthDataList.stream().map(growthData -> {
                HerbLocation location = locationMap.get(growthData.getLocationId());
                HerbGrowthDataDto dto = new HerbGrowthDataDto();
                
                dto.setGrowthDataId(growthData.getId());
                dto.setMetricName(growthData.getMetricName());
                dto.setMetricValue(growthData.getMetricValue());
                dto.setMetricUnit(growthData.getMetricUnit());
                dto.setRecordedAt(growthData.getRecordedAt());

                if (location != null) {
                    dto.setLocationId(location.getId());
                    dto.setProvince(location.getProvince());
                    dto.setCity(location.getCity());
                    dto.setAddress(location.getAddress());
                    dto.setObservationYear(location.getObservationYear());
                }
                return dto;
            }).collect(Collectors.toList());

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new SystemException(Code.SYSTEM_ERR, "系统异常，查询药材生长数据失败", e);
        }
    }

    @Override
    public IPage<Herb> getHerbsByPage(Integer pageNum, Integer pageSize, String name, String scientificName, String familyName, String resourceType, String lifeForm, String sortBy, String order) {
        // 1. 创建分页对象
        Page<Herb> page = new Page<>(pageNum, pageSize);

        // 2. 创建查询条件构造器
        LambdaQueryWrapper<Herb> queryWrapper = new LambdaQueryWrapper<>();

        // 3. 动态拼接查询条件
        queryWrapper.like(Strings.isNotEmpty(name), Herb::getName, name);
        queryWrapper.eq(Strings.isNotEmpty(scientificName), Herb::getScientificName, scientificName);
        queryWrapper.eq(Strings.isNotEmpty(familyName), Herb::getFamilyName, familyName);
        queryWrapper.eq(Strings.isNotEmpty(resourceType), Herb::getResourceType, resourceType);

        // [!code focus:16]
        // --- 核心修复：重写生活型(lifeForm)的查询逻辑 ---
        if (Strings.isNotEmpty(lifeForm)) {
            // 打印日志，方便调试，您可以在后端控制台看到接收到的原始参数
            log.info("接收到 lifeForm 原始参数: '{}'", lifeForm);

            // 将前端传来的 "一年生,草本" 字符串分割并去除可能的空格
            String[] lifeForms = Arrays.stream(lifeForm.split(","))
                    .map(String::trim)
                    .filter(Strings::isNotEmpty)
                    .toArray(String[]::new);

            if (lifeForms.length > 0) {
                // 再次打印日志，确认分割后的关键词
                log.info("正在为 life_form 字段应用筛选关键词: {}", Arrays.toString(lifeForms));

                // 为每一个关键词（如 "一年生", "草本"）都添加一个 AND LIKE 条件
                // 这将确保最终结果的 life_form 字段同时包含所有这些关键词
                for (String form : lifeForms) {
                    queryWrapper.like(Herb::getLifeForm, form);
                }
            }
        }

        // 4. 处理排序
        boolean isAsc = "asc".equalsIgnoreCase(order);
        if (Strings.isNotEmpty(sortBy)) {
            // 默认按name排序，这里可以根据实际需求扩展
            queryWrapper.orderBy(true, isAsc, Herb::getName);
        }

        // 5. 执行查询
        return this.page(page, queryWrapper);
    }

    /**
     * 实现获取所有药材上传详情的逻辑
     */
    @Override
    public List<HerbUploadDetailDto> getAllHerbUploadDetails() {
        // 1. 获取所有地理位置记录作为基础
        List<HerbLocation> locations = herbLocationDao.selectList(null);
        if (locations.isEmpty()) {
            return Collections.emptyList();
        }
        List<Long> locationIds = locations.stream().map(HerbLocation::getId).collect(Collectors.toList());

        // 2. 批量获取药材信息
        List<Long> herbIds = locations.stream().map(HerbLocation::getHerbId).distinct().collect(Collectors.toList());
        Map<Long, String> herbNameMap = this.listByIds(herbIds).stream()
                .collect(Collectors.toMap(Herb::getId, Herb::getName));

        // 3. 批量获取图片链接
        Map<Long, List<String>> imagesMap = herbImageDao
                .selectList(new LambdaQueryWrapper<HerbImage>().in(HerbImage::getLocationId, locationIds))
                .stream()
                .collect(Collectors.groupingBy(HerbImage::getLocationId, Collectors.mapping(HerbImage::getUrl, Collectors.toList())));

        // 4. 批量获取生长数据
        Map<Long, List<HerbGrowthData>> growthDataMap = herbGrowthDataDao
                .selectList(new LambdaQueryWrapper<HerbGrowthData>().in(HerbGrowthData::getLocationId, locationIds))
                .stream()
                .collect(Collectors.groupingBy(HerbGrowthData::getLocationId));

        // 5. 批量获取历史记录以确定上传者 (这是关键修正)
        Map<Long, String> uploaderNameMap = historyDao
                .selectList(new LambdaQueryWrapper<HerbGrowthDataHistory>().in(HerbGrowthDataHistory::getLocationId, locationIds).eq(HerbGrowthDataHistory::getAction, "CREATE"))
                .stream()
                .collect(Collectors.toMap(
                        HerbGrowthDataHistory::getLocationId,
                        HerbGrowthDataHistory::getChangedBy,
                        (existing, replacement) -> existing // 如果一个地点有多个CREATE记录，保留第一个
                ));

        // 6. 最终组装
        return locations.stream().map(location -> {
            HerbUploadDetailDto dto = new HerbUploadDetailDto();
            BeanUtils.copyProperties(location, dto); // 复制基础属性
            dto.setLocationId(location.getId());

            dto.setHerbName(herbNameMap.get(location.getHerbId()));
            dto.setUploaderName(uploaderNameMap.get(location.getId())); // 从正确的Map获取上传者
            dto.setImageUrls(imagesMap.getOrDefault(location.getId(), Collections.emptyList()));

            // 填充生长数据
            List<HerbGrowthData> growthList = growthDataMap.get(location.getId());
            if (growthList != null) {
                dto.setGrowthData(growthList.stream().map(data -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("metricName", data.getMetricName());
                    map.put("metricValue", data.getMetricValue());
                    map.put("metricUnit", data.getMetricUnit());
                    return map;
                }).collect(Collectors.toList()));
            }

            return dto;
        }).collect(Collectors.toList());
    }
}
