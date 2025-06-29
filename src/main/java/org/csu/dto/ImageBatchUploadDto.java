package org.csu.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import lombok.Data;
import java.util.List;

/**
 * 批量图片上传传输对象
 */
@Data
public class ImageBatchUploadDto {

    @NotEmpty(message = "图片列表不能为空")
    @Valid // 确保对列表中的每个元素都进行校验
    private List<ImageInfoDto> images;
} 