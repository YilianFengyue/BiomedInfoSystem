package org.csu.dto;

import lombok.Data;

import java.sql.Date;

@Data
public class PaperVO {
    private Long id;
    private String title;
    private String authors;
    private String publication;
    private Date publishDate;
    private String doi;
    private String abstractText;
    private String keywords;
    private Integer citationCount;
    private String fileUrl;
    private Long projectId;
} 