package com.semi.spring.board.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Notice {
	private int noticeNo;         
    private String title;         
    private Date postDate;         
    private String noticeContent;
    private int readCount; // READ_COUNT
	public int getViews() { return readCount; }
}
