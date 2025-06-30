package org.csu.service;

import com.baomidou.mybatisplus.extension.service.IService;
import org.csu.domain.EduCategories;
import org.csu.dto.CategoryDto;

import java.util.List;

/**
 * 教学资源分类服务接口
 */
public interface IEduCategoriesService extends IService<EduCategories> {

    /**
     * 【新增】查询所有分类，并转换为DTO列表
     * @return CategoryDto 列表
     */
    List<CategoryDto> findAll();

    /**
     * 【新增】根据DTO创建一个新的分类
     * @param categoryDTO 包含分类信息的数据传输对象
     * @return 创建成功后的分类DTO（包含ID）
     */
    CategoryDto create(CategoryDto categoryDTO);

    /**
     * 【新增】根据ID和DTO更新一个分类
     * @param id 要更新的分类ID
     * @param categoryDTO 包含新分类信息的数据传输对象
     * @return 更新成功后的分类DTO
     */
    CategoryDto update(Integer id, CategoryDto categoryDTO);

    /**
     * 【新增】根据ID删除一个分类
     * @param id 要删除的分类ID
     */
    void delete(Integer id);
}