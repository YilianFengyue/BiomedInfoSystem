package org.csu.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.csu.domain.EduResources;
import org.csu.dao.EduResourcesDao;
import org.csu.dto.EduResourcesDto;
import org.csu.service.IEduResourcesService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 教学资源主表 服务实现类
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Service
public class EduResourcesServiceImpl extends ServiceImpl<EduResourcesDao, EduResources> implements IEduResourcesService {
    @Override
    public IPage<EduResourcesDto> getResourcesWithAuthorByPage(Page<EduResourcesDto> page) {
        return this.baseMapper.selectResourcesWithAuthor(page);
    }
}
