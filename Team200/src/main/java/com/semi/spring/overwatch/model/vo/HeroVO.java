package com.semi.spring.overwatch.model.vo;

import lombok.Data;

@Data
public class HeroVO {
    private int heroNo;
    private String heroName;
    private String heroIntro;
    private int heroHp;
    private String heroPosition;
    private String heroImg; // 리스트 화면용 프로필 이미지
}