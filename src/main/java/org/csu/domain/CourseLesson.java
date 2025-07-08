package org.csu.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.io.Serializable;
import java.sql.Timestamp;

@Data
@TableName("course_lesson")
public class CourseLesson implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long chapterId;
    private Long courseId;
    private String title;
    private String contentType;
    private String contentUrl;
    private String content;
    private Integer duration;
    private Integer sortOrder;
    private boolean isFree;
    private Integer viewCount;
    private Timestamp createdAt;
}