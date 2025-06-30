package org.csu.dao;

import com.baomidou.mybatisplus.core.metadata.IPage;
import org.csu.domain.EduResources;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import org.apache.ibatis.annotations.Mapper;
import org.csu.dto.EduResourcesDto;

/**
 * <p>
 * 教学资源主表 Mapper 接口
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Mapper
public interface EduResourcesDao extends BaseMapper<EduResources> {

    /**
     * 分页查询教学资源列表，并关联作者姓名
     * @param page 分页参数
     * @return 包含作者姓名的资源分页列表
     */
    IPage<EduResourcesDto> selectResourcesWithAuthor(IPage<EduResourcesDto> page);

}

