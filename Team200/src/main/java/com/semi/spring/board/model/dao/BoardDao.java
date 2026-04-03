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
import com.semi.spring.board.model.vo.GameInfoReply;
import com.semi.spring.board.model.vo.Inquiry;
import com.semi.spring.board.model.vo.Patchnote;
import com.semi.spring.board.model.vo.Reply;
import com.semi.spring.board.model.vo.Report;
import com.semi.spring.common.model.vo.PageInfo;

public interface BoardDao {

	public List<Board> selectList(Map<String, Object> paramMap);
	
//	public Map<String, Object> getCategoryTableMap(String gameCode);

	public int selectListCount(Map<String, Object> paramMap);
	
	public int insertBoard(Board board);
	
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

	public int insertInquiry(Inquiry inquiry);

	public int selectInquiryCount(Map<String, Object> paramMap);

	public List<Inquiry> selectInquiryList(PageInfo pi, Map<String, Object> paramMap);

	public int deleteBoard(int boardNo);

	public int updateBoard(Board board);

	public void deleteSelectedFile(int fileNo);

	public Inquiry selectInquiryDetail(int boardNo);

	public int deleteInquiry(int boardNo);

	public int selectMyBoardsCount(Map<String, Object> paramMap);

	public List<BoardExt> selectMyBoards(PageInfo pi, Map<String, Object> paramMap);

	public int selectMyRepliesCount(Map<String, Object> paramMap);
	
	public List<Map<String, Object>> selectMyReplies(PageInfo pi, Map<String, Object> paramMap);
	
	public int deleteMyReplies(Map<String, Object> paramMap);
	
	public List<GameInfoReply> selectInfoReplies(Map<String, Object> paramMap);

    public int insertInfoReply(GameInfoReply reply);

	public int deleteInfoReply(GameInfoReply reply);
	
	public int insertReport(Report report);

	public List<BoardExt> selectGalleryList(Map<String, Object> paramMap);

	public int selectGalleryCount(Map<String, Object> paramMap);

	public List<BoardExt> selectRecentGallery(String gameCode);

	public int selectPatchnoteCount(Map<String, Object> paramMap);

	public List<BoardExt> selectPatchnoteList(Map<String, Object> paramMap);
	
	public BoardExt selectPatchnoteDetail(int boardNo);
	
	public int updateOfficialReadCount(Map<String, Object> paramMap);

	public List<BoardExt> selectNoticeList(Map<String, Object> paramMap);

	public BoardExt selectNoticeDetail(int boardNo);

	public int selectNoticeCount(Map<String, Object> paramMap);

	public List<BoardExt> selectMainPatchNotes();

	public List<BoardExt> selectMainNotices();

	public List<BoardExt> selectPatchnoteListForSide(Map<String, Object> paramMap);
	
	
}
