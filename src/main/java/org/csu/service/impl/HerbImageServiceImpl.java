package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.csu.dao.HerbImageDao;
import org.csu.domain.HerbImage;
import org.csu.domain.HerbLocation;
import org.csu.dto.ImageUploadDto;
import org.csu.service.IHerbImageService;
import org.csu.service.IHerbLocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
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
    @Transactional(rollbackFor = Exception.class) // 保证事务性，任何异常都会导致回滚
    public HerbImage saveImageAndLocation(ImageUploadDto uploadDto) {
        // 第一步：创建并保存HerbLocation实体
        HerbLocation location = new HerbLocation();
        location.setHerbId(uploadDto.getHerbId());
        location.setLongitude(uploadDto.getLongitude());
        location.setLatitude(uploadDto.getLatitude());
        location.setProvince(uploadDto.getProvince());
        location.setCity(uploadDto.getCity());
        location.setAddress(uploadDto.getAddress());
        location.setObservationYear(uploadDto.getObservationYear());
        location.setCreatedAt(LocalDateTime.now());
        
        herbLocationService.save(location); // 保存后，location对象的id字段会被MyBatisPlus自动填充

        // 第二步：创建并保存HerbImage实体
        HerbImage image = new HerbImage();
        image.setHerbId(uploadDto.getHerbId());
        image.setUrl(uploadDto.getUrl());
        image.setIsPrimary(uploadDto.getIsPrimary());
        image.setDescription(uploadDto.getDescription());
        image.setUploadedAt(LocalDateTime.now());
        
        // 关键：使用上一步生成的locationId
        image.setLocationId(location.getId()); 

        this.save(image); // 保存图片信息

        return image;
    }
}
