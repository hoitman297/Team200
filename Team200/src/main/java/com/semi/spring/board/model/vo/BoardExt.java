package com.semi.spring.board.model.vo;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class BoardExt extends Board{
	private String userName;
	private List<AttachFile> fileList;
	private PartyRecruit party;
}
