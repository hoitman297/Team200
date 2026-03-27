package com.semi.spring.board.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.semi.spring.board.model.dao.BoardDao;
import com.semi.spring.board.model.vo.Board;
import com.semi.spring.board.model.vo.BoardExt;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {

	private final BoardDao boardDao;
	
	@Override
	public Map<String, Object> getCategoryTableMap(String gameCode) {
		System.out.println("gameCode : " + gameCode);
		return boardDao.getCategoryTableMap(gameCode);
	}
	
	@Override
	public int selectListCount(Map<String, Object> paramMap) {
		return boardDao.selectListCount(paramMap);
	}

	@Override
	public List<Board> selectList(Map<String, Object> paramMap) {
		return boardDao.selectList(paramMap);
	}

	@Override
	public int increaseCount(int boardNo) {
		return boardDao.increaseCount(boardNo);
	}

	@Override
	public BoardExt selectBoard(int boardNo) {
		return boardDao.selectBoard(boardNo);
	}

	@Override
	public int insertBoard(Board board, List<MultipartFile> upFiles, String savePath) {
		return boardDao.insertBoard(board, upFiles, savePath);
	}

	@Override
	public Map<String, Object> getBoardTypeMap(String boardType) {
		return boardDao.getBoardTypeMap(boardType);
	}


}
