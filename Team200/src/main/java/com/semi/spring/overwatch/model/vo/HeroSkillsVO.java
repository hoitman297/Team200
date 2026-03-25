package com.semi.spring.overwatch.model.vo;

import java.util.List;

import com.semi.spring.lol.model.vo.ChampionVO;
import com.semi.spring.lol.model.vo.SkillVO;
import com.semi.spring.lol.model.vo.SkinVO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
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
    
    private String skillPName;
    private String skillPDesc;
    private String skillPImg;
    // Getter, Setter도 꼭 추가해 주세요!
}