package org.csu.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import org.hibernate.validator.constraints.URL;

/**
 * 单张图片信息传输对象
 */
@Data
public class ImageInfoDto {

    @NotBlank(message = "图片URL不能为空")
    @URL(message = "必须是有效的URL格式")
    private String url;

    @JsonProperty("Primary")
    private boolean Primary;

    private String description;
} 