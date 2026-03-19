package com.semi.spring.board.model.vo;

import java.util.Date;

import com.semi.spring.board.model.vo.Board;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Board {
	private int boardNo;
	private String boardTitle;
	private String boardContent;
	private String boardCd;
	private String boardWriter; // userId, userName
	
	private int count;
	private Date postDate;
}
