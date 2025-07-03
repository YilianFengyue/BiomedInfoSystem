package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.csu.config.BusinessException;
import org.csu.controller.Code;
import org.csu.dao.EduCategoriesDao;
import org.csu.dao.EduResourcesDao;
import org.csu.dao.EduResourceVideoLinkDao;
import org.csu.dao.UsersDao;
import org.csu.domain.EduCategories;
import org.csu.domain.EduResources;
import org.csu.domain.EduResourceVideoLink;
import org.csu.domain.Users;
import org.csu.dto.*;
import org.csu.service.IEduResourcesService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils; // 导入

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 教学资源服务实现类 (已使用项目中定义的错误码抛出异常)
 */
@Service
public class EduResourceServiceImpl extends ServiceImpl<EduResourcesDao, EduResources> implements IEduResourcesService {

    private final EduCategoriesDao categoryDao;
    private final EduResourceVideoLinkDao resourceVideoLinkDao;
    private final UsersDao usersDao;

    @Autowired
    public EduResourceServiceImpl(EduCategoriesDao categoryDao, EduResourceVideoLinkDao resourceVideoLinkDao, UsersDao usersDao) {
        this.categoryDao = categoryDao;
        this.resourceVideoLinkDao = resourceVideoLinkDao;
        this.usersDao = usersDao;
    }

    @Override
    @Transactional(readOnly = true)
    public org.springframework.data.domain.Page<ResourceListDto> findPaginated(Integer categoryId, String title, String status, Pageable pageable) {

        LambdaQueryWrapper<EduResources> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(categoryId != null, EduResources::getCategoryId, categoryId);
        queryWrapper.like(StringUtils.hasText(title), EduResources::getTitle, title);

        // 【关键新增】如果status参数不为空，则添加状态过滤条件
        queryWrapper.eq(StringUtils.hasText(status), EduResources::getStatus, status);

        queryWrapper.orderByDesc(EduResources::getCreatedAt);

        com.baomidou.mybatisplus.extension.plugins.pagination.Page<EduResources> mpPage = new com.baomidou.mybatisplus.extension.plugins.pagination.Page<>(pageable.getPageNumber() + 1, pageable.getPageSize());
        baseMapper.selectPage(mpPage, queryWrapper);

        List<EduResources> resources = mpPage.getRecords();
        if (CollectionUtils.isEmpty(resources)) {
            return new PageImpl<>(Collections.emptyList(), pageable, 0);
        }

        List<Integer> categoryIds = resources.stream().map(EduResources::getCategoryId).distinct().collect(Collectors.toList());
        List<Long> authorIds = resources.stream().map(EduResources::getAuthorId).distinct().collect(Collectors.toList());

        Map<Integer, String> categoryMap = categoryDao.selectBatchIds(categoryIds).stream()
                .collect(Collectors.toMap(EduCategories::getId, EduCategories::getName));
        Map<Long, String> authorMap = usersDao.selectBatchIds(authorIds).stream()
                .collect(Collectors.toMap(Users::getId, Users::getUsername));

        List<ResourceListDto> dtoList = resources.stream().map(resource -> {
            ResourceListDto dto = new ResourceListDto();
            BeanUtils.copyProperties(resource, dto);
            dto.setCategoryName(categoryMap.get(resource.getCategoryId()));
            dto.setAuthorName(authorMap.get(resource.getAuthorId()));
            return dto;
        }).collect(Collectors.toList());

        return new PageImpl<>(dtoList, pageable, mpPage.getTotal());
    }

    @Override
    @Transactional(readOnly = true)
    public ResourceDetailDto findById(Long id) {
        EduResources resource = this.getById(id);
        if (resource == null) {

            throw new BusinessException(Code.GET_ERR, "查询失败：教学资源未找到, ID: " + id);
        }

        EduCategories category = categoryDao.selectById(resource.getCategoryId());
        Users author = usersDao.selectById(resource.getAuthorId());

        ResourceDetailDto detailDTO = new ResourceDetailDto();
        BeanUtils.copyProperties(resource, detailDTO);
        if (category != null) {
            detailDTO.setCategoryName(category.getName());
        }
        if (author != null) {
            detailDTO.setAuthorName(author.getUsername());
        }
        return detailDTO;
    }

    @Override
    @Transactional
    public ResourceDetailDto create(ResourceCreateDto createDTO) {
        boolean categoryExists = categoryDao.exists(
                new LambdaQueryWrapper<EduCategories>().eq(EduCategories::getId, createDTO.getCategoryId())
        );
        if (!categoryExists) {
            // 【修改点】使用您定义的Code.SAVE_ERR
            throw new BusinessException(Code.SAVE_ERR, "新增失败：指定的分类不存在, CategoryID: " + createDTO.getCategoryId());
        }

        Long currentUserId = 1L;

        EduResources resource = new EduResources();
        BeanUtils.copyProperties(createDTO, resource);
        resource.setAuthorId(currentUserId);

        this.save(resource);
        return this.findById(resource.getId());
    }

    @Override
    @Transactional
    public ResourceDetailDto update(Long id, ResourceUpdateDto updateDTO) {
        EduResources existingResource = this.getById(id);
        if (existingResource == null) {

            throw new BusinessException(Code.UPDATE_ERR, "更新失败：教学资源不存在, ID: " + id);
        }

        BeanUtils.copyProperties(updateDTO, existingResource);
        this.updateById(existingResource);
        return this.findById(id);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        boolean resourceExists = this.exists(new LambdaQueryWrapper<EduResources>().eq(EduResources::getId, id));
        if (!resourceExists) {

            throw new BusinessException(Code.DELETE_ERR, "删除失败：教学资源不存在, ID: " + id);
        }

        LambdaQueryWrapper<EduResourceVideoLink> linkQueryWrapper = new LambdaQueryWrapper<>();
        linkQueryWrapper.eq(EduResourceVideoLink::getResourceId, id);
        resourceVideoLinkDao.delete(linkQueryWrapper);

        this.removeById(id);
    }

    @Override
    @Transactional // 保证操作的原子性
    public void linkVideo(Long resourceId, LinkVideoDto linkVideoDTO) {
        // 1. 校验资源是否存在
        if (this.getById(resourceId) == null) {
            throw new BusinessException(Code.GET_ERR, "关联失败：指定的教学资源不存在");
        }

        // 2. (可选) 校验视频是否存在
        // if (videoService.getById(linkVideoDTO.getVideoId()) == null) {
        //     throw new BusinessException(Code.BUSINESS_ERR, "关联失败：指定的视频不存在");
        // }

        // 3. 检查是否已经关联，避免重复插入
        LambdaQueryWrapper<EduResourceVideoLink> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(EduResourceVideoLink::getResourceId, resourceId)
                .eq(EduResourceVideoLink::getVideoId, linkVideoDTO.getVideoId());
        if (resourceVideoLinkDao.exists(queryWrapper)) {
            // 如果已经存在，可以直接返回成功，或者抛出异常提示已关联
            return;
        }

        // 4. 创建新的关联关系实体
        EduResourceVideoLink newLink = new EduResourceVideoLink();
        newLink.setResourceId(resourceId);
        newLink.setVideoId(linkVideoDTO.getVideoId());
        // (可选) 可以在DTO中传入其他信息，如排序字段等
        // newLink.setSortOrder(linkVideoDTO.getSortOrder());

        // 5. 插入到数据库
        resourceVideoLinkDao.insert(newLink);
    }

    /**
     * 实现 unlinkVideo 方法
     * 逻辑：根据资源ID和视频ID删除关联记录
     */
    @Override
    @Transactional
    public void unlinkVideo(Long resourceId, Long videoId) {
        // 1. 构建删除条件
        LambdaQueryWrapper<EduResourceVideoLink> deleteWrapper = new LambdaQueryWrapper<>();
        deleteWrapper.eq(EduResourceVideoLink::getResourceId, resourceId)
                .eq(EduResourceVideoLink::getVideoId, videoId);

        // 2. 执行删除操作
        // .delete() 方法会根据wrapper中的条件删除匹配的记录
        // 如果没有匹配的记录，该操作不会报错
        resourceVideoLinkDao.delete(deleteWrapper);
    }

    @Override
    public IPage<EduResourcesDto> getResourcesWithAuthorByPage(com.baomidou.mybatisplus.extension.plugins.pagination.Page<EduResourcesDto> page) {
        return this.baseMapper.selectResourcesWithAuthor(page);
    }

    @Override
    @Transactional
    public void updateStatus(Long id, String status) {
        EduResources existingResource = this.getById(id);
        if (existingResource == null) {
            throw new BusinessException(Code.UPDATE_ERR, "更新失败：教学资源不存在, ID: " + id);
        }

        existingResource.setStatus(status);

        // 如果状态是“发布”，且之前没有发布时间，则设置发布时间
        if ("published".equals(status) && existingResource.getPublishedAt() == null) {
            existingResource.setPublishedAt(LocalDateTime.now());
        }

        this.updateById(existingResource);
    }
}