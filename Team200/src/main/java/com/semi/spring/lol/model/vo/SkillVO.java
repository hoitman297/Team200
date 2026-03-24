package com.semi.spring.lol.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SkillVO {
    private int champNo;
    
    private String skillPName;
    private String skillPDesc;
    private String skillPImg;
    
    private String skillQName;
    private String skillQDesc;
    private String skillQImg;
    
    private String skillWName;
    private String skillWDesc;
    private String skillWImg;
    
    private String skillEName;
    private String skillEDesc;
    private String skillEImg;
    
    private String skillRName;
    private String skillRDesc;
    private String skillRImg;
}