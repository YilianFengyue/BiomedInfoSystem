package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.csu.dao.HerbImageDao;
import org.csu.domain.HerbImage;
import org.csu.domain.HerbLocation;
import org.csu.dto.ImageBatchUploadDto;
import org.csu.dto.ImageInfoDto;
import org.csu.service.IHerbImageService;
import org.csu.service.IHerbLocationService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * <p>
 * 药材图片表 服务实现类
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Service
public class HerbImageServiceImpl extends ServiceImpl<HerbImageDao, HerbImage> implements IHerbImageService {
    @Autowired
    private HerbImageDao herbImageDao;

    @Autowired
    private IHerbLocationService herbLocationService;

    @Override
    public List<String> getImagesByHerbId(Long herbId) {
        LambdaQueryWrapper<HerbImage> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(HerbImage::getHerbId, herbId);
        queryWrapper.select(HerbImage::getUrl); // 只查询 url 字段

        List<HerbImage> herbImages = herbImageDao.selectList(queryWrapper);

        // 使用Stream API提取URL列表
        return herbImages.stream()
                .map(HerbImage::getUrl) // 使用正确的字段名 getUrl
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public List<HerbImage> saveImagesForLocation(Long locationId, ImageBatchUploadDto uploadDto) {
        // 1. 验证Location是否存在
        HerbLocation location = herbLocationService.getById(locationId);
        if (location == null) {
            // 在实际应用中，最好抛出一个自定义的业务异常
            throw new RuntimeException("指定的观测点ID不存在: " + locationId);
        }
        Long herbId = location.getHerbId(); // 获取关联的药草ID

        List<HerbImage> savedImages = new ArrayList<>();
        for (ImageInfoDto imageInfo : uploadDto.getImages()) {
            HerbImage image = new HerbImage();
            BeanUtils.copyProperties(imageInfo, image);

            image.setLocationId(locationId);
            image.setHerbId(herbId); // 关键：设置药草ID
            image.setUploadedAt(LocalDateTime.now());

            this.save(image);
            savedImages.add(image);
        }
        return savedImages;
    }
}
