package com.semi.spring.board.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Reply {
	private int replyNo;         
    private int userNo;           
    private int boardNo;          
    
    private String replyContent;  
    private Date replyDate;      
    private String status;       
    
    private int parentReplyNo;    
}
