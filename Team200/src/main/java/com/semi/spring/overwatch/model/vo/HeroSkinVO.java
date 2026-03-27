package com.semi.spring.overwatch.model.vo;

import lombok.Data;

@Data
public class HeroSkinVO {
    private int heroSkinNo;     // 스킨 번호 (시퀀스)
    private int heroNo;         // 영웅 번호 (FK)
    private String heroSkinName;// 스킨 이름
    private String heroSkinImg; // 스킨 이미지 URL
}