package org.csu.dto;

import lombok.Data;
import java.util.List;

@Data
public class ChapterDto {
    private Long id;
    private String title;
    private List<LessonDto> lessons;
}