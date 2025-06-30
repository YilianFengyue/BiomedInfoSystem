package org.csu.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class CategoryDto {
    private Integer id;
    @NotBlank
    private String name;
    @NotBlank
    @Pattern(regexp = "^[a-z0-9-]+$", message = "分类别名只能包含小写字母、数字和连字符")
    private String slug;
    private String description;
}
