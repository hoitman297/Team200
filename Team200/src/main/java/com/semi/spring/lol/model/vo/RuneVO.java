package com.semi.spring.lol.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RuneVO {
    private int runeNo;      // RUNE_NO (PK, 시퀀스)
    private String runeName;  // RUNE_NAME (룬 이름: 예 - 정밀)
    private String runeInfo;  // RUNE_INFO (룬 설명 또는 영문 Key)
    private String runeImg;   // RUNE_IMG (룬 아이콘 이미지 경로)
}