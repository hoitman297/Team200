package com.semi.spring.board.model.vo;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat; // ✨ 이거 임포트!

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Reply {
    private int replyNo;         
    private int userNo;            
    private int boardNo;          
    
    private String replyContent;  
    
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy.MM.dd HH:mm", timezone = "Asia/Seoul")
    private Date replyDate;      
    
    private String status;       
    
    private int parentReplyNo;    
    
    private String userName;
}