package com.semi.spring.lol.model.vo;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChampionVO {
    private int champNo;          // CHAMP_NO (PK, 시퀀스)
    private String champName;     // CHAMP_NAME 
    private String champPosition; // CHAMP_POSITION 
    private String champRoles;    // CHAMP_ROLES 
    private String champImg;      // CHAMP_IMG 
    private String champIntro;
    
    private String id;            // API에서 키값으로 사용하는 영문명

    //스킬과 스킨 정보
    private SkillVO skills;       
    private List<SkinVO> skins;   

    private RecommendBuildVO recommendBuild;
}
