package org.csu.dao.research;

import org.csu.domain.research.Project;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import org.apache.ibatis.annotations.Mapper;

/**
 * <p>
 * 科研项目表 Mapper 接口
 * </p>
 *
 * @author YinBo
 * @since 2025-07-08
 */
@Mapper
public interface ProjectDao extends BaseMapper<Project> {

}

