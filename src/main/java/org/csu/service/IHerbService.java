package org.csu.service;

import org.csu.domain.Herb;
import org.csu.dto.HerbDistributionDto;
import org.csu.dto.HerbGrowthDataDto;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import org.csu.dto.HerbUploadDetailDto;
import org.csu.dto.HerbUploadDto;

import java.util.List;

/**
 * <p>
 * 药材主信息表 服务类
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
public interface IHerbService extends IService<Herb> {

    //新增药材信息
    boolean createHerb(Herb herb);

    //根据ID删除药材信息
    boolean deleteHerbById(Long id);

    //更新药材信息
    boolean updateHerb(Herb herb);

    //根据ID查询药材信息
    Herb getHerbById(Long id);

    //*查询所有药材信息
    List<Herb> getAllHerbs();

    /**
     * 获取药材地理分布数据，用于地图可视化
     * 
     * @param province 可选参数，按省份筛选，不传则查询全部
     * @return 药材分布数据列表
     */
    List<HerbDistributionDto> getHerbDistribution(String province);

    /**
     * 根据药材ID获取其所有生长数据记录，用于对比分析
     *
     * @param herbId 药材ID
     * @return 药材生长数据列表
     */
    List<HerbGrowthDataDto> getGrowthDataForHerb(Long herbId);

    /**
     * 分页、条件查询和排序获取药材列表
     * @param page 页码
     * @param limit 每页数量
     * @param name 药材名称 (模糊)
     * @param scientificName 学名 (模糊)
     * @param familyName 科名 (精确)
     * @param resourceType 资源类型 (精确)
     * @param sortBy 排序字段
     * @param order 排序顺序 ('asc' or 'desc')
     * @return 分页结果对象
     */
    IPage<Herb> getHerbsByPage(Integer page, Integer limit, String name, String scientificName, String familyName, String resourceType, String lifeForm, String sortBy, String order);
    /**
     * 【新增 V2】获取所有药材上传的详细数据记录
     * @return 包含所有上传详情的列表
     */
    List<HerbUploadDetailDto> getAllHerbUploadDetails();
}
