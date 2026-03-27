package com.semi.spring.board.model.dao;

import java.util.List;
import java.util.Map;

import com.semi.spring.board.model.vo.AttachFile;
import com.semi.spring.board.model.vo.Board;
import com.semi.spring.board.model.vo.BoardExt;
import com.semi.spring.board.model.vo.Notice;
import com.semi.spring.board.model.vo.Patchnote;

public interface BoardDao {

	public List<Board> selectList(Map<String, Object> paramMap);
	
	public int selectListCount(Map<String, Object> paramMap);
	
	public int insertBoard(Board board);
	
//	public int updateBoard(Board board);
	
	public List<BoardExt> selectBestBoards();
	public List<Notice> selectNotice();
	public List<Patchnote> selectPatchnoteList(Map<String, Object> paramMap);

	public BoardExt selectBoard(int boardNo);

	public void increaseCount(int boardNo);

	public int insertAttachFileList(List<AttachFile> attachFileList);
}
