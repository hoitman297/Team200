package com.semi.spring.board.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Report {
	
	    private int reportNo;
	    private int userNo;       
	    private Integer boardNo;  
	    private Integer replyNo; 
	    private String content;
	    private String status;  
	    private Date doneDate;
	    private String reportType; 
	
}
