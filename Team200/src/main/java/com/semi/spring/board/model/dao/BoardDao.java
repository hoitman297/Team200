package com.semi.spring.board.model.dao;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.semi.spring.board.model.vo.Board;
import com.semi.spring.board.model.vo.BoardExt;
import com.semi.spring.board.model.vo.BoardImg;

public interface BoardDao {

	public List<Board> selectList(Map<String, Object> paramMap);
	
	public Map<String, Object> getCategoryTableMap(String gameCode);

	public int selectListCount(Map<String, Object> paramMap);
	
	public int insertBoard(Board board);
	
	public int insertBoardImgList(List<BoardImg> imgList);
	
	public int insertBoardImg(BoardImg bi);
	
	public int deleteBoardImg(String deleteList);
	
	public int updateBoard(Board board);

	public int increaseCount(int boardNo);

	public BoardExt selectBoard(int boardNo);

	public int insertBoard(Board board, List<MultipartFile> upFiles, String savePath);

	public Map<String, Object> getBoardTypeMap(String boardType);

	
}
