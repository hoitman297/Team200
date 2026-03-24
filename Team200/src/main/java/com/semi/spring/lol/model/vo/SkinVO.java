package com.semi.spring.lol.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SkinVO {
    private int champSkinNo;
    private int champNo;
    private String champSkinName;
    private String champSkinImg;
}