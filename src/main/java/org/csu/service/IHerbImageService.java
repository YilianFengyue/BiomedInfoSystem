package org.csu.service;

import org.csu.domain.HerbImage;
import com.baomidou.mybatisplus.extension.service.IService;
import org.csu.dto.ImageBatchUploadDto;

import java.util.List;

/**
 * <p>
 * 药材图片表 服务类
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
public interface IHerbImageService extends IService<HerbImage> {
    /**
     * 根据药草ID获取其所有图片URL列表
     * @param herbId 药草ID
     * @return 图片URL列表
     */
    List<String> getImagesByHerbId(Long herbId);

    /**
     * 为指定的观测点批量保存图片
     * @param locationId 观测点ID
     * @param uploadDto 包含多张图片信息的DTO
     * @return 保存后的图片实体对象列表
     */
    List<HerbImage> saveImagesForLocation(Long locationId, ImageBatchUploadDto uploadDto);
}
