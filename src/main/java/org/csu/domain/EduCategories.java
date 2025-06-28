package org.csu.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
/**
 * <p>
 * 教学资源分类表
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Getter
@Setter
@ToString
@TableName("edu_categories")
public class EduCategories implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 分类主键ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    /**
     * 分类名称 (如: 试验课程, 课题研究)
     */
    private String name;

    /**
     * 分类别名 (用于URL, e.g., experiment-course)
     */
    private String slug;

    /**
     * 分类描述
     */
    private String description;
}
