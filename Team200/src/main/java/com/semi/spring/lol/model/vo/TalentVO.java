package com.semi.spring.lol.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TalentVO {
    private int talentNo;    // TALENT_NO (PK, 시퀀스)
    private int runeNo;      // RUNE_NO (FK, 소속된 룬 빌드 번호)
    private String talentName; // TALENT_NAME (특성 이름)
    private String talentInfo; // TALENT_INFO (특성 상세 설명)
    private String talentImg;  // TALENT_IMG (특성 이미지 경로)
}