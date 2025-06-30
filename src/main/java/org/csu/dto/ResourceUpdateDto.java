package org.csu.dto;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class ResourceUpdateDto {
    @NotBlank(message = "资源标题不能为空")
    private String title;

    @NotNull(message = "必须关联一个分类")
    private Integer categoryId;

    private String coverImageUrl;

    @NotBlank(message = "资源内容不能为空")
    private String content; // 富文本内容

    @Pattern(regexp = "draft|published|archived", message = "无效的状态值")
    private String status;
}
