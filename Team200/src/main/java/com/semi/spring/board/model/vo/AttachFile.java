package com.semi.spring.board.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class AttachFile {
	private int fileNo;        
    private int boardNo;        
    private String gameCode;
    
    private String originName;  
    private String changeName;  
    private String filePath;    
    private String fileExt;     
    private long fileSize;
}
