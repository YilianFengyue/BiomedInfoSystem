package org.csu.service;


import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.csu.domain.EduResources;
import com.baomidou.mybatisplus.extension.service.IService;
import org.csu.dto.EduResourcesDto;
import org.csu.dto.*;
import org.springframework.data.domain.Pageable;


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
     * 【修改】分页查询，增加status筛选
     */
    org.springframework.data.domain.Page<ResourceListDto> findPaginated(Integer categoryId, String title, String status, Pageable pageable);

    // 查询详情 (需要连表)
    ResourceDetailDto findById(Long id);

    // 创建资源
    ResourceDetailDto create(ResourceCreateDto createDTO);

    // 更新资源
    ResourceDetailDto update(Long id, ResourceUpdateDto updateDTO);

    // 删除资源
    void delete(Long id);


    void linkVideo(Long resourceId, LinkVideoDto linkVideoDTO);


    void unlinkVideo(Long resourceId, Long videoId);

    /**
     * 分页查询教学资源，并包含作者姓名
     * @param page 分页参数
     * @return 包含作者姓名的资源分页列表
     */
    IPage<EduResourcesDto> getResourcesWithAuthorByPage(Page<EduResourcesDto> page);


    /**
     * 更新单个资源的状态
     * @param id 资源ID
     * @param status 新的状态
     */
    void updateStatus(Long id, String status);
}
