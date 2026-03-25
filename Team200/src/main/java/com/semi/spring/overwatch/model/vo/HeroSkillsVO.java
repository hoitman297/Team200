package com.semi.spring.overwatch.model.vo;

import lombok.Data;

@Data
public class HeroSkillsVO {
    private int heroNo;
    
    // 좌클릭 (기본 무기)
    private String skillLclickName;
    private String skillLclickDesc;
    private String skillLclickImg;
    
    // 우클릭
    private String skillRclickName;
    private String skillRclickDesc;
    private String skillRclickImg;
    
    // Shift
    private String skillShiftName;
    private String skillShiftDesc;
    private String skillShiftImg;
    
    // E
    private String skillEName;
    private String skillEDesc;
    private String skillEImg;
    
    // Q (궁극기)
    private String skillQName;
    private String skillQDesc;
    private String skillQImg;
}