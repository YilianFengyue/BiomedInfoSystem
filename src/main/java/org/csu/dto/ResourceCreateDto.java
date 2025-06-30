package org.csu.dto;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;


@Data
public class ResourceCreateDto {
    @NotBlank(message = "资源标题不能为空")
    private String title;

    @NotNull(message = "必须关联一个分类")
    private Integer categoryId;

    // author_id 通常从当前登录用户获取，不在DTO中传递

    private String coverImageUrl;

    @NotBlank(message = "资源内容不能为空")
    private String content; // 富文本内容

    private String status = "draft";
}
