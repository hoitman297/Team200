package com.semi.spring.board.model.dao;

import java.util.List;
import java.util.Map;

import com.semi.spring.board.model.vo.Board;
import com.semi.spring.board.model.vo.BoardImg;

public interface BoardDao {

public List<Board> selectList(Map<String, Object> paramMap);
	
	public int selectListCount(Map<String, Object> paramMap);
	
	public int insertBoard(Board board);
	
	public int insertBoardImgList(List<BoardImg> imgList);
	
	public int insertBoardImg(BoardImg bi);
	
	public int deleteBoardImg(String deleteList);
	
	public int updateBoard(Board board);
}
