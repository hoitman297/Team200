package com.semi.spring.board.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.web.multipart.MultipartFile;

import com.semi.spring.board.model.vo.AttachFile;
import com.semi.spring.board.model.vo.Board;
import com.semi.spring.board.model.vo.BoardExt;
import com.semi.spring.board.model.vo.BoardLike;
import com.semi.spring.board.model.vo.BoardType;
import com.semi.spring.board.model.vo.Inquiry;
import com.semi.spring.board.model.vo.Reply;

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

	public int checkBoardLike(BoardLike boardLike);

	public void insertBoardLike(BoardLike boardLike);

	public int selectBoardLikeCount(int boardNo);

	public List<BoardExt> selectBestBoards(@Param("gameCode") String string);

	public List<Reply> selectReplyList(int boardNo);

	public int insertReply(Reply reply);

	public int deleteReply(Map<String, Object> paramMap);

	public int selectCategoryNoByName(Map<String, Object> map);

	public int selectGalleryCount(String game);

	public List<BoardExt> selectGalleryList(Map<String, Object> map);

	public int insertInquiry(Inquiry inquiry);

	
}
