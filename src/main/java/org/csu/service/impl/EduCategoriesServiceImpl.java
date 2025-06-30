package org.csu.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.csu.config.BusinessException;
import org.csu.controller.Code;
import org.csu.dao.EduCategoriesDao;
import org.csu.domain.EduCategories;
import org.csu.dto.CategoryDto;
import org.csu.service.IEduCategoriesService;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class EduCategoriesServiceImpl extends ServiceImpl<EduCategoriesDao, EduCategories> implements IEduCategoriesService {

    /**
     * 解决错误一：实现 findAll 方法
     * 逻辑：查询所有实体，然后将它们逐个转换为DTO
     */
    @Override
    public List<CategoryDto> findAll() {
        // 1. 使用MyBatis-Plus的list()方法查询所有实体
        List<EduCategories> categoryEntities = this.list();

        // 2. 使用Stream API将List<EduCategories>转换为List<CategoryDto>
        return categoryEntities.stream().map(entity -> {
            CategoryDto dto = new CategoryDto();
            BeanUtils.copyProperties(entity, dto);
            return dto;
        }).collect(Collectors.toList());
    }

    /**
     * 解决错误二：实现 create 方法
     * 逻辑：将传入的DTO转换为实体，保存到数据库，再将保存后的实体转回DTO返回
     */
    @Override
    public CategoryDto create(CategoryDto categoryDTO) {
        // 1. 创建一个新的实体对象
        EduCategories entity = new EduCategories();
        // 2. 将DTO的属性复制到实体中 (BeanUtils会自动忽略ID)
        BeanUtils.copyProperties(categoryDTO, entity);

        // 3. 使用MyBatis-Plus的save()方法保存实体
        this.save(entity);

        // 4. 将保存后带有ID的实体属性复制回DTO并返回
        BeanUtils.copyProperties(entity, categoryDTO);
        return categoryDTO;
    }

    /**
     * 解决错误三：实现 update 方法
     * 逻辑：先根据ID查询出实体，再用DTO的属性更新它，最后保存
     */
    @Override
    public CategoryDto update(Integer id, CategoryDto categoryDTO) {
        // 1. 根据ID查询数据库中已存在的实体
        EduCategories existingEntity = this.getById(id);

        // 2. 检查实体是否存在，不存在则抛出异常
        if (existingEntity == null) {
            throw new BusinessException(Code.UPDATE_ERR, "更新失败：未找到ID为 " + id + " 的分类");
        }

        // 3. 将DTO的属性复制到已存在的实体中进行更新
        BeanUtils.copyProperties(categoryDTO, existingEntity);
        existingEntity.setId(id); // 确保ID不会被覆盖

        // 4. 使用MyBatis-Plus的updateById()方法更新数据库
        this.updateById(existingEntity);

        // 5. 将更新后的实体信息返回
        return categoryDTO;
    }

    /**
     * 实现 delete 方法
     * 逻辑：删除前可以增加业务校验，例如检查该分类下是否还有资源
     */
    @Override
    public void delete(Integer id) {
        // 1. 检查要删除的分类是否存在
        EduCategories existingEntity = this.getById(id);
        if (existingEntity == null) {
            throw new BusinessException(Code.DELETE_ERR, "删除失败：未找到ID为 " + id + " 的分类");
        }

        // (可选) 在这里可以增加业务逻辑，例如：
        // if (resourceService.countByCategoryId(id) > 0) {
        //     throw new BusinessException(Code.DELETE_ERR, "删除失败：该分类下还有教学资源，无法删除");
        // }

        // 2. 使用MyBatis-Plus的removeById()方法进行删除
        this.removeById(id);
    }
}