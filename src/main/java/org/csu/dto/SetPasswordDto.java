package org.csu.dto;


import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Data
public class SetPasswordDto {
    @NotEmpty
    private String new_pwd;
    @NotEmpty
    private String re_pwd;
}



