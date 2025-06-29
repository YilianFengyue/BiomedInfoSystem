package org.csu.service;

import org.csu.domain.HerbImage;
import com.baomidou.mybatisplus.extension.service.IService;
import org.csu.dto.ImageUploadDto;

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
     * [核心方法] 保存图片及其关联的地点信息
     * 这是一个事务性操作
     * @param uploadDto 包含图片和地点信息的DTO
     * @return 保存后的图片实体对象
     */
    HerbImage saveImageAndLocation(ImageUploadDto uploadDto);
}
