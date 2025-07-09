package org.csu.dto;

import lombok.Data;

@Data
public class ProgressUpdateDTO {
    private String progressContent;
    private String progressType;
    private String attachments;
}