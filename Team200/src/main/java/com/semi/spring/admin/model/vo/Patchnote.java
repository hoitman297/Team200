package com.semi.spring.admin.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Patchnote {
	private int patchnoteNo;
	private String gameCode;
	private String title;
	private Date postDate;
	private String patchnoteContent;
	
}
