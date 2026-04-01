package com.semi.spring.admin.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Notice {
	private int noticeNo;
	private String title;
	private Date postDate;
	private String noticeContent;
}
