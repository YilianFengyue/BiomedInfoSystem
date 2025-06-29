package org.csu.service;

import org.csu.domain.HerbLocation;
import com.baomidou.mybatisplus.extension.service.IService;
import org.csu.dto.LocationCreateDto;

/**
 * <p>
 * 药材地理分布(观测点)表 服务类
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
public interface IHerbLocationService extends IService<HerbLocation> {
    /**
     * 创建一个新的观测点
     * @param createDto 包含观测点信息的DTO
     * @return 创建的HerbLocation实体
     */
    HerbLocation createLocation(LocationCreateDto createDto);
}
