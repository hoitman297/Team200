package com.semi.spring.board.model.dao;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.semi.spring.board.model.vo.AttachFile;
import com.semi.spring.board.model.vo.Board;
import com.semi.spring.board.model.vo.BoardExt;
import com.semi.spring.board.model.vo.BoardType;

public interface BoardDao {

	public List<Board> selectList(Map<String, Object> paramMap);
	
//	public Map<String, Object> getCategoryTableMap(String gameCode);

	public int selectListCount(Map<String, Object> paramMap);
	
	public int insertBoard(Board board);
	
	public int updateBoard(Board board);

	public int increaseCount(int boardNo);

	public BoardExt selectBoard(int boardNo);

	public int insertBoard(Board board, List<MultipartFile> upFiles, String savePath);

	public BoardType getBoardTypeMap(String dbGameCode , String boardType);
	
	public int insertAttachFileList(List<AttachFile> attachFileList);

	
}
