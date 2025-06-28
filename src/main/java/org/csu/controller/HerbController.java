package org.csu.controller;

import org.csu.controller.Result;
import org.csu.dto.HerbDistributionDto;
import org.csu.service.IHerbService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 药材信息控制器
 * 负责处理药材相关的HTTP请求
 * 
 * @author YilianFengyue
 */
@RestController
@RequestMapping("/herb")
@CrossOrigin(origins = "*")
public class HerbController {

    @Autowired
    private IHerbService herbService;

    /**
     * 获取药材地理分布数据 (用于地图可视化)
     * 
     * @param province 可选参数，按省份筛选，不传则查询全部
     * @return 药材分布数据列表
     */
    @GetMapping("/map/herb-distribution")
    public Result<List<HerbDistributionDto>> getHerbDistribution(
            @RequestParam(required = false) String province) {
        List<HerbDistributionDto> distributionData = herbService.getHerbDistribution(province);
        return Result.success(distributionData);
    }

    /**
     * 获取药材列表
     * 
     * @param page 页码，默认为1
     * @param limit 每页数量，默认为10
     * @param name 药材名称模糊查询
     * @param scientificName 学名模糊查询
     * @param familyName 科名查询
     * @param resourceType 资源类型筛选 ('野生', '栽培')
     * @param sortBy 排序字段，默认为'name'
     * @param order 排序顺序，默认为'asc'
     * @return 分页的药材列表
     */
    @GetMapping("/herbs")
    public Result<?> getHerbs(
            @RequestParam(value = "page", defaultValue = "1") Integer page,
            @RequestParam(value = "limit", defaultValue = "10") Integer limit,
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "scientific_name", required = false) String scientificName,
            @RequestParam(value = "family_name", required = false) String familyName,
            @RequestParam(value = "resource_type", required = false) String resourceType,
            @RequestParam(value = "sort_by", defaultValue = "name") String sortBy,
            @RequestParam(value = "order", defaultValue = "asc") String order) {
        
        try {
            // TODO: 实现分页查询逻辑
            return Result.success("药材列表查询功能待实现");
        } catch (Exception e) {
            return Result.error("获取药材列表失败: " + e.getMessage());
        }
    }

    /**
     * 获取单个药材详情
     * 
     * @param id 药材ID
     * @return 药材详细信息
     */
    @GetMapping("/herbs/{id}")
    public Result<?> getHerbById(@PathVariable Long id) {
        try {
            // TODO: 实现获取药材详情逻辑
            return Result.success("药材详情查询功能待实现");
        } catch (Exception e) {
            return Result.error("获取药材详情失败: " + e.getMessage());
        }
    }

    /**
     * 创建新的药材条目
     * 
     * @param herbDto 药材数据传输对象
     * @return 创建结果
     */
    @PostMapping("/herbs")
    public Result<?> createHerb(@RequestBody Object herbDto) {
        try {
            // TODO: 实现创建药材逻辑
            return Result.success("药材创建功能待实现");
        } catch (Exception e) {
            return Result.error("创建药材失败: " + e.getMessage());
        }
    }

    /**
     * 更新药材信息
     * 
     * @param id 药材ID
     * @param herbDto 更新的药材数据
     * @return 更新结果
     */
    @PutMapping("/herbs/{id}")
    public Result<?> updateHerb(@PathVariable Long id, @RequestBody Object herbDto) {
        try {
            // TODO: 实现更新药材逻辑
            return Result.success("药材更新功能待实现");
        } catch (Exception e) {
            return Result.error("更新药材失败: " + e.getMessage());
        }
    }

    /**
     * 删除药材
     * 
     * @param id 药材ID
     * @return 删除结果
     */
    @DeleteMapping("/herbs/{id}")
    public Result<?> deleteHerb(@PathVariable Long id) {
        try {
            // TODO: 实现删除药材逻辑
            return Result.success("药材删除功能待实现");
        } catch (Exception e) {
            return Result.error("删除药材失败: " + e.getMessage());
        }
    }

    /**
     * 获取指定药材的图片列表 - 用于图谱比对UI
     * 
     * @param herbId 药材ID
     * @return 图片列表
     */
    @GetMapping("/herbs/{herbId}/images")
    public Result<?> getHerbImages(@PathVariable Long herbId) {
        try {
            // TODO: 实现获取药材图片逻辑
            return Result.success("药材图片查询功能待实现");
        } catch (Exception e) {
            return Result.error("获取药材图片失败: " + e.getMessage());
        }
    }
}
