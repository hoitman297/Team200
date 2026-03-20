package com.semi.spring.lol.model.vo;

import java.util.Date;

import org.springframework.web.context.annotation.RequestScope;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChampionVO {
	private String name; // 가렌, 아리 등
	private String engName; // garen, ahri (이미지 파일명용)

}
