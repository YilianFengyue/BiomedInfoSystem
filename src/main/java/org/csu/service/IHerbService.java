package org.csu.service;

import org.csu.domain.Herb;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

/**
 * <p>
 * 药材主信息表 服务类
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
public interface IHerbService extends IService<Herb> {

    //新增药材信息
    boolean createHerb(Herb herb);

    //根据ID删除药材信息
    boolean deleteHerbById(Long id);

    //更新药材信息
    boolean updateHerb(Herb herb);

    //根据ID查询药材信息
    Herb getHerbById(Long id);

    //*查询所有药材信息
    List<Herb> getAllHerbs();
}
