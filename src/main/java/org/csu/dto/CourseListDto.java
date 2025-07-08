package org.csu.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class CourseListDto {
    private Long id;
    private String title;
    private String teacherName;
    private String coverImage;
    private Integer studentCount;
    private BigDecimal rating;
}