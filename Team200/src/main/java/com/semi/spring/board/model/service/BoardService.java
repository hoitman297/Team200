package com.semi.spring.board.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.semi.spring.board.model.vo.Board;
import com.semi.spring.board.model.vo.BoardExt;

public interface BoardService {

	Map<String, Object> getBoardTypeMap(String boardType);
	
	Map<String, Object> getCategoryTableMap(String gameCode);

	int selectListCount(Map<String, Object> paramMap);

	List<Board> selectList(Map<String, Object> paramMap);

	int increaseCount(int boardNo);

	BoardExt selectBoard(int boardNo);

	int insertBoard(Board board, List<MultipartFile> upFiles, String savePath);

	

	


}
