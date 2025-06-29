// src/main/java/org/csu/dto/HerbImageDto.java
package org.csu.dto;

import lombok.Data;

/**
 * 用于接收前端上传的药草图片信息的DTO
 */
@Data
public class HerbImageDto {

    /**
     * 关联的药草ID (必需)
     */
    private Long herbId;

    /**
     * 图片的URL地址 (必需)
     */
    private String url;

    /**
     * 【可选】关联的观测点ID
     */
    private Long locationId;

    /**
     * 【可选】是否为主图 (默认为false)
     */
    private Boolean isPrimary = false;

    /**
     * 【可选】图片描述
     */
    private String description;
}
