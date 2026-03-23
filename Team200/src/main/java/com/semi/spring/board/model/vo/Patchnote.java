package com.semi.spring.board.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Patchnote {
	private int patchnoteNo;          
    private String gameCode;         
    private String title;             
    private Date postDate;            
    private String patchnoteContent;
}
