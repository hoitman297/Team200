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
	private String boardType;
	
//	private String boardWriter; // userId, userName
	private String userId;
	private String userName;
	private int userNo; 
	 
	private int readCount; // READ_COUNT
	private Date postDate;
	
	private String gameCode;     
    private String categoryName; 
    
    private int categoryNo;
    
    private int replyCount;
    private int likeCount;
}

