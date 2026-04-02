package com.semi.spring.board.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.semi.spring.board.model.vo.Board;
import com.semi.spring.board.model.vo.BoardExt;
import com.semi.spring.board.model.vo.BoardType;
import com.semi.spring.board.model.vo.GameInfoReply;
import com.semi.spring.board.model.vo.Inquiry;
import com.semi.spring.board.model.vo.Reply;
import com.semi.spring.board.model.vo.Report;
import com.semi.spring.common.model.vo.PageInfo;

public interface BoardService {

//	Map<String, Object> getBoardTypeMap(String boardType);
	
//	Map<String, Object> getCategoryTableMap(String gameCode);

	int selectListCount(Map<String, Object> paramMap);

	List<Board> selectList(Map<String, Object> paramMap);

	int increaseCount(int boardNo);

	BoardExt selectBoard(int boardNo);

	int insertBoard(Board board, List<MultipartFile> upFiles, String savePath);

	BoardType getBoardTypeMap(String dbGameCode, String boardType);

	int insertBoardLike(int boardNo, int userNo);

	List<BoardExt> selectBestBoards(String gameCode);

	List<Reply> selectReplyList(int boardNo);

	int insertReply(Reply reply);

	int deleteReply(Map<String, Object> paramMap);

	int insertInquiry(Inquiry inquiry);

	int selectInquiryCount(Map<String, Object> paramMap);

	List<Inquiry> selectInquiryList(PageInfo pi, Map<String, Object> paramMap);

	int updateBoard(Board board, List<MultipartFile> upFiles, List<Integer> deleteFileNos, String savePath);

	int deleteBoard(int boardNo);

	Inquiry selectInquiryDetail(int boardNo);

	int deleteInquiry(int boardNo);

	int selectMyBoardsCount(Map<String, Object> paramMap);

	List<BoardExt> selectMyBoards(PageInfo pi, Map<String, Object> paramMap);

	int selectMyRepliesCount(Map<String, Object> paramMap);

	List<Map<String, Object>> selectMyReplies(PageInfo pi, Map<String, Object> paramMap);
	
	int deleteMyReplies(Map<String, Object> paramMap);
	
    List<GameInfoReply> selectInfoReplies(Map<String, Object> paramMap);

    int insertInfoReply(GameInfoReply reply);
    
    int deleteInfoReply(GameInfoReply reply);
    
    int insertReport(Report report);
    
    List<BoardExt> selectGalleryList(Map<String, Object> paramMap);

    int selectGalleryCount(Map<String, Object> paramMap);
    
    int selectCategoryNoByName(Map<String, Object> paramMap);

	List<BoardExt> selectRecentGallery(String gameCode);
}
