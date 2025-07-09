package org.csu.dao.research;

import org.csu.domain.research.PaperSubmission;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import org.apache.ibatis.annotations.Mapper;

/**
 * <p>
 * 论文提交表 Mapper 接口
 * </p>
 *
 * @author YinBo
 * @since 2025-07-08
 */
@Mapper
public interface PaperSubmissionDao extends BaseMapper<PaperSubmission> {

}

