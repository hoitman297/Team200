package com.semi.spring.board.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Category {
	private int categoryNo;
    private String categoryName;
    private String gameCode;
}
