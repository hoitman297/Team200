package com.semi.spring.lol.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChampionVO {
	private int champNo;          // CHAMP_NO (PK, 시퀀스)
    private String champName;     // CHAMP_NAME (가렌, 아리 등)
    private String champPosition; // CHAMP_POSITION (암살자, 탱커 등 - API의 'tags')
    private String champRoles;    // CHAMP_ROLES (탑, 미드 등 - 별도 관리 필요)
    private String champImg;      // CHAMP_IMG (이미지 URL 경로)

    // 2. API 처리를 위한 추가 필드 (필요시)
    private String id;            // API에서 키값으로 사용하는 영문명 (예: Garen, Akali)

}
