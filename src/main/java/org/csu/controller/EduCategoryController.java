package org.csu.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.csu.dto.CategoryDto;
import org.csu.service.IEduCategoriesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/categories")
@Tag(name = "教学资源分类管理", description = "用于管理教学资源的分类，如试验课程、课题研究等")
public class EduCategoryController {

    @Autowired
    private IEduCategoriesService categoryService; // 假设已创建Service层

    @GetMapping
    @Operation(summary = "获取所有分类列表")
    public Result<List<CategoryDto>> getAllCategories() {
        return Result.success(categoryService.findAll());
    }

    @PostMapping
    @Operation(summary = "创建一个新的分类")
    public Result<CategoryDto> createCategory(@Valid @RequestBody CategoryDto categoryDTO) {
        CategoryDto createdCategory = categoryService.create(categoryDTO);
        return Result.success(createdCategory);
    }

    @PutMapping("/{id}")
    @Operation(summary = "更新指定ID的分类")
    public Result<CategoryDto> updateCategory(@PathVariable Integer id, @Valid @RequestBody CategoryDto categoryDTO) {
        CategoryDto updatedCategory = categoryService.update(id, categoryDTO);
        return Result.success(updatedCategory);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除指定ID的分类")
    public Result<Void> deleteCategory(@PathVariable Integer id) {
        categoryService.delete(id);
        return Result.success();
    }
}
