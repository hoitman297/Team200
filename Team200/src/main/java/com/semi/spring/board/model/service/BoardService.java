package com.semi.spring.board.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.semi.spring.board.model.vo.Board;
import com.semi.spring.board.model.vo.BoardExt;
import com.semi.spring.board.model.vo.Notice;
import com.semi.spring.board.model.vo.Patchnote;

public interface BoardService {

	// 기존 목록 조회
	int selectListCount(Map<String, Object> paramMap);
	List<Board> selectList(Map<String, Object> paramMap);

	// 메인페이지용 추가
	List<BoardExt> selectBestBoards(); // 인기 게시글 TOP 5
    List<Notice> selectNotice();       // 공지사항
    List<Patchnote> selectPatchnoteList(Map<String, Object> paramMap); // 패치노트
    
    int insertBoard(Board board,List<MultipartFile> upFiles, String savePath);
    
	void increaseCount(int boardNo);
	BoardExt selectBoard(int boardNo);
}
