package org.csu.service.impl;

import org.csu.domain.HerbLocation;
import org.csu.dao.HerbLocationDao;
import org.csu.dto.LocationCreateDto;
import org.csu.service.IHerbLocationService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

/**
 * <p>
 * 药材地理分布(观测点)表 服务实现类
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Service
public class HerbLocationServiceImpl extends ServiceImpl<HerbLocationDao, HerbLocation> implements IHerbLocationService {
    @Override
    @Transactional
    public HerbLocation createLocation(LocationCreateDto createDto) {
        HerbLocation location = new HerbLocation();
        BeanUtils.copyProperties(createDto, location);
        location.setCreatedAt(LocalDateTime.now());
        this.save(location);
        return location;
    }
}
