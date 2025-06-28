package org.csu.service.impl;

import org.csu.domain.Herb;
import org.csu.domain.HerbLocation;
import org.csu.dao.HerbDao;
import org.csu.dao.HerbLocationDao;
import org.csu.dto.HerbDistributionDto;
import org.csu.service.IHerbService;
import org.csu.config.BusinessException;
import org.csu.config.SystemException;
import org.csu.controller.Code;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import lombok.extern.slf4j.Slf4j;

import java.util.List;
import java.util.stream.Collectors;

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
}
