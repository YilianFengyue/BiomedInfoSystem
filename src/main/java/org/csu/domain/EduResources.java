package org.csu.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
/**
 * <p>
 * 教学资源主表
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Getter
@Setter
@ToString
@TableName("edu_resources")
public class EduResources implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 资源主键ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 资源标题
     */
    private String title;

    /**
     * 外键：关联的分类ID
     */
    private Integer categoryId;

    /**
     * 外键：作者的用户ID
     */
    private Long authorId;

    /**
     * 封面图片URL
     */
    private String coverImageUrl;

    /**
     * 资源主体内容 (由富文本编辑器生成)
     */
    private String content;

    /**
     * 状态 (draft-草稿, published-已发布, archived-已归档)
     */
    private String status;

    /**
     * 创建时间
     */
    private LocalDateTime createdAt;

    /**
     * 更新时间
     */
    private LocalDateTime updatedAt;

    /**
     * 发布时间
     */
    private LocalDateTime publishedAt;
}
