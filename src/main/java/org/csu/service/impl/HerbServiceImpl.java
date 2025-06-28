package org.csu.service.impl;

import org.csu.domain.Herb;
import org.csu.dao.HerbDao;
import org.csu.service.IHerbService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <p>
 * 药材主信息表 服务实现类
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Service
public class HerbServiceImpl extends ServiceImpl<HerbDao, Herb> implements IHerbService {
    // ServiceImpl 已经自动注入了 baseMapper (即 HerbDao)，可以直接使用
    @Override
    public boolean createHerb(Herb herb) {
        // 使用 Mybatis-Plus 自带的 save 方法，插入成功会返回 true
        return save(herb);
    }

    @Override
    public boolean deleteHerbById(Long id) {
        // 使用 Mybatis-Plus 自带的 removeById 方法
        int rows = baseMapper.deleteById(id);
        return rows > 0;
    }

    @Override
    public boolean updateHerb(Herb herb) {
        // 使用 Mybatis-Plus 自带的 updateById 方法
        int rows = baseMapper.updateById(herb);
        return rows > 0;
    }

    @Override
    public Herb getHerbById(Long id) {
        return baseMapper.selectById(id);
    }

    @Override
    public List<Herb> getAllHerbs() {
        // selectList(null) 表示查询所有
        return baseMapper.selectList(null);
    }
}
