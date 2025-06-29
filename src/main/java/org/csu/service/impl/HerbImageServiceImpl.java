package org.csu.service.impl;

import org.csu.domain.HerbImage;
import org.csu.dao.HerbImageDao;
import org.csu.service.IHerbImageService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 药材图片表 服务实现类
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
//@Service
//public class HerbImageServiceImpl extends ServiceImpl<HerbImageDao, HerbImage> implements IHerbImageService {
//    @Autowired
//    private HerbImageDao herbImageDao;
//
//    @Override
//    public List<String> getImagesByHerbId(Long herbId) {
//        LambdaQueryWrapper<HerbImage> queryWrapper = new LambdaQueryWrapper<>();
//        queryWrapper.eq(HerbImage::getHerbId, herbId);
//        queryWrapper.select(HerbImage::getImageUrl); // 只查询image_url字段，提高效率
//
//        List<HerbImage> herbImages = herbImageDao.selectList(queryWrapper);
//
//        // 使用Stream API提取URL列表
//        return herbImages.stream()
//                .map(HerbImage::getImageUrl)
//                .collect(Collectors.toList());
//    }
//
//}
