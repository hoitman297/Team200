package com.semi.spring.board.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor	
public class BoardLike {
	private int userNo;
	private int boardNo;
}
