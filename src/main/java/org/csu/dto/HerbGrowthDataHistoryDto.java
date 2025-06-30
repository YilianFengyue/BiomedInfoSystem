// src/main/java/org/csu/dto/HerbGrowthDataHistoryDto.java

package org.csu.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;
import org.csu.domain.HerbGrowthDataHistory;

@Data
@EqualsAndHashCode(callSuper = true)
public class HerbGrowthDataHistoryDto extends HerbGrowthDataHistory {

    private String herbName;
    private String address;

}