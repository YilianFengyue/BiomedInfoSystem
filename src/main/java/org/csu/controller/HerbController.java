package org.csu.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import jakarta.validation.Valid;
import org.csu.domain.Herb;
import org.csu.domain.HerbImage;
import org.csu.domain.HerbGrowthData;
import org.csu.dto.HerbDistributionDto;
import org.csu.dto.HerbDto;
import org.csu.dto.HerbGrowthDataDto;
import org.csu.dto.ImageUploadDto;
import org.csu.service.IHerbImageService;
import org.csu.service.IHerbService;
import org.csu.service.IHerbGrowthDataService;
import org.springframework.beans.BeanUtils;
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

    @Autowired
    private IHerbImageService herbImageService;

    @Autowired
    private IHerbGrowthDataService growthDataService;

    /**
     * 获取药材地理分布数据 (用于地图可视化)
     * 
     * @param province 可选参数，按省份筛选，不传则查询全部
     * @return 药材分布数据列表
     */
    @GetMapping("/map/herb-distribution")
    public Result<List<HerbDistributionDto>> getHerbDistribution(@RequestParam(required = false) String province) {
        return Result.success(herbService.getHerbDistribution(province));
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
    public Result<IPage<Herb>> getHerbs(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer limit,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String scientificName,
            @RequestParam(required = false) String familyName,
            @RequestParam(required = false) String resourceType,
            @RequestParam(defaultValue = "name") String sortBy,
            @RequestParam(defaultValue = "asc") String order) {
        IPage<Herb> herbPage = herbService.getHerbsByPage(page, limit, name, scientificName, familyName, resourceType, sortBy, order);
        return Result.success(herbPage);
    }

    /**
     * 根据药材名称智能分页查询
     *
     * @param name  查询的药材名称关键字
     * @param page  当前页码
     * @param limit 每页数量
     * @return 分页的药材列表
     */
    @GetMapping("/herbs/searchByName")
    public Result<IPage<Herb>> searchHerbsByName(
            @RequestParam String name,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer limit) {
        // 直接复用现有的分页服务，只传入name参数进行模糊查询
        IPage<Herb> herbPage = herbService.getHerbsByPage(page, limit, name, null, null, null, "name", "asc");
        return Result.success(herbPage);
    }

    /**
     * 获取单个药材详情
     * 
     * @param id 药材ID
     * @return 药材详细信息
     */
    @GetMapping("/herbs/{id}")
    public Result<Herb> getHerbById(@PathVariable Long id) {
        Herb herb = herbService.getById(id);
        if (herb == null) {
            return Result.error(Code.GET_ERR, "未找到指定ID的药材");
        }
        return Result.success(herb);
    }

    /**
     * 创建新的药材条目
     * 
     * @param herbDto 药材数据传输对象
     * @return 创建结果
     */
    @PostMapping("/herbs")
    public Result<Herb> createHerb(@Valid @RequestBody HerbDto herbDto) {
        Herb herb = new Herb();
        BeanUtils.copyProperties(herbDto, herb);
        boolean success = herbService.save(herb);
        return success ? Result.success(herb) : Result.error(Code.SAVE_ERR, "创建药材失败");
    }

    /**
     * 更新药材信息
     * 
     * @param id 药材ID
     * @param herbDto 更新的药材数据
     * @return 更新结果
     */
    @PutMapping("/herbs/{id}")
    public Result<Herb> updateHerb(@PathVariable Long id, @Valid @RequestBody HerbDto herbDto) {
        Herb herb = new Herb();
        BeanUtils.copyProperties(herbDto, herb);
        herb.setId(id); // 确保ID被设置
        boolean success = herbService.updateById(herb);
        return success ? Result.success(herbService.getById(id)) : Result.error(Code.UPDATE_ERR, "更新药材失败");
    }

    /**
     * 删除药材
     * 
     * @param id 药材ID
     * @return 删除结果
     */
    @DeleteMapping("/herbs/{id}")
    public Result<Void> deleteHerb(@PathVariable Long id) {
        boolean success = herbService.removeById(id);
        return success ? Result.success() : Result.error(Code.DELETE_ERR, "删除药材失败");
    }

    /**
     * 获取指定药材的图片URL列表
     * @param herbId 药材ID
     * @return 图片URL列表
     */
    @GetMapping("/herbs/{herbId}/images")
    public Result<List<String>> getHerbImages(@PathVariable Long herbId) {
        return Result.success(herbImageService.getImagesByHerbId(herbId));
    }

    /**
     * 保存一张新的药材图片及其关联的地点信息
     * @param uploadDto 包含图片和地点信息的DTO
     * @return 操作结果
     */
    @PostMapping("/herbs/images")
    public Result<HerbImage> saveImageWithLocation(@Valid @RequestBody ImageUploadDto uploadDto) {
        HerbImage savedImage = herbImageService.saveImageAndLocation(uploadDto);
        return new Result<>(Code.SUCCESS, savedImage, "图片及地点信息保存成功");
    }

    /**
     * 获取指定药材的生长数据记录
     *
     * @param herbId 药材ID
     * @return 该药材在所有观测点的生长数据列表
     */
    @GetMapping("/{herbId}/growth-data")
    public Result<List<HerbGrowthDataDto>> getGrowthDataForHerb(@PathVariable Long herbId) {
        return new Result<>(Code.GET_OK, herbService.getGrowthDataForHerb(herbId), "查询成功");
    }

    /**
     * 更新药材生长数据，并记录历史
     * @param id 生长数据的ID
     * @param dto 包含更新信息的DTO
     * @return 操作结果
     */
    @PutMapping("/growth-data/{id}")
    public Result<Void> updateGrowthData(@PathVariable Long id, @Valid @RequestBody HerbGrowthDataDto dto) {
        HerbGrowthData growthData = new HerbGrowthData();
        // 我们只从DTO中获取需要更新的字段和ID
        BeanUtils.copyProperties(dto, growthData);
        growthData.setId(id); // 确保ID是从路径参数中获取的，更安全

        boolean success = growthDataService.updateGrowthDataAndLogHistory(growthData);

        return success
                ? Result.success()
                : Result.error(Code.UPDATE_ERR, "更新失败，未找到对应数据或发生内部错误");
    }
}
