package org.csu.dto;

import lombok.Data;
import java.util.List;

@Data
public class CourseDetailDto {
    private Long id;
    private String title;
    private String teacherName;
    private String coverImage;
    private List<ChapterDto> chapters;
}