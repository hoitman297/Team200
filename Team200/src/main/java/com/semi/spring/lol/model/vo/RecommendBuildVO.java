package com.semi.spring.lol.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RecommendBuildVO {
    private int champNo;
    
    // 추천 코어 아이템 번호 3개
    private Integer itemNo1;
    private Integer itemNo2;
    private Integer itemNo3;
    
    // 추천 핵심 룬 번호 4개
    private Integer talentNo1;
    private Integer talentNo2;
    private Integer talentNo3;
    private Integer talentNo4;
}