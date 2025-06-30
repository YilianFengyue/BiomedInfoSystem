package org.csu.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;
import org.csu.domain.EduResources;

@Data
@EqualsAndHashCode(callSuper = true)
public class EduResourcesDto extends EduResources {

    /**
     * 作者姓名 (从 user_profiles.nickname 获取)
     */
    private String authorName;
}