package org.csu.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.csu.domain.EduResources;
import com.baomidou.mybatisplus.extension.service.IService;
import org.csu.dto.EduResourcesDto;

/**
 * <p>
 * 教学资源主表 服务类
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
public interface IEduResourcesService extends IService<EduResources> {

    /**
     * 分页查询教学资源，并包含作者姓名
     * @param page 分页参数
     * @return 包含作者姓名的资源分页列表
     */
    IPage<EduResourcesDto> getResourcesWithAuthorByPage(Page<EduResourcesDto> page);

}
