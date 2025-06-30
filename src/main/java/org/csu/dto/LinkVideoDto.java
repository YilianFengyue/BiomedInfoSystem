package org.csu.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class LinkVideoDto {
    @NotNull
    private Long videoId;
    private int displayOrder = 0;
}