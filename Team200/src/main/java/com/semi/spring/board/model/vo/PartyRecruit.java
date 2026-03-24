package com.semi.spring.board.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PartyRecruit {
	private int boardNo;      
    private int capacity;     
    private String tier;      
    private String partyCurrent;   
    private String preferMap;
}
