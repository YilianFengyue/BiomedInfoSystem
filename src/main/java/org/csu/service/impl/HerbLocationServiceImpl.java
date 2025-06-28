package org.csu.service.impl;

import org.csu.domain.HerbLocation;
import org.csu.dao.HerbLocationDao;
import org.csu.service.IHerbLocationService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

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

}
