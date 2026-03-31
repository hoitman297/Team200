package com.semi.spring.board.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Inquiry {
	private int boardNo;
	private int userNo;
	private String userName;
	private String boardContent; 
	private String boardTitle;
	private Date postDate;
	private String answerStatus; // 'W' or 'C'
	private String reason;
	private String answer;     
	private String gameCode;
}
