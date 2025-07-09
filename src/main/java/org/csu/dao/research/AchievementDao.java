package org.csu.dao.research;

import org.csu.domain.research.Achievement;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import org.apache.ibatis.annotations.Mapper;

/**
 * <p>
 * 科研成果表(论文、专利等) Mapper 接口
 * </p>
 *
 * @author YinBo
 * @since 2025-07-08
 */
@Mapper
public interface AchievementDao extends BaseMapper<Achievement> {

}

