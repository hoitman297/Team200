package com.semi.spring.board.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartFile;

import com.semi.spring.board.model.vo.AttachFile;
import com.semi.spring.board.model.vo.Board;
import com.semi.spring.board.model.vo.BoardExt;
import com.semi.spring.board.model.vo.BoardType;
import com.semi.spring.common.model.vo.PageInfo;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
@RequiredArgsConstructor
public class BoardDaoImpl implements BoardDao {

	private final SqlSessionTemplate session;
	
//	@Override
//	public Map<String, Object> getBoardTypeMap(String boardType) {
//		return session.selectOne("board.getBoardTypeMap", "boardType");
//	}
	
//	@Override
//	public Map<String, Object> getCategoryTableMap(String gameCode) {
//		return session.selectOne("board.getCategoryTableMap", gameCode);
//	}
	
	@Override
	public List<Board> selectList(Map<String, Object> paramMap) {
		
		PageInfo pi = (PageInfo) paramMap.get("pi");
		int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
		int limit = pi.getBoardLimit();

		paramMap.put("offset",offset + 1);
		paramMap.put("limit", limit+offset);
		
		return session.selectList("board.selectList",paramMap);
	}
	
	@Override
	public int selectListCount(Map<String, Object> paramMap) {
		return session.selectOne("board.selectListCount", paramMap);
	}

	@Override
	public int insertBoard(Board board) {
		return session.insert("board.insertBoard",board);
	}

	@Override
	public int updateBoard(Board board) {
		return session.update("board.updateBoard",board);
	}

	@Override
	public int increaseCount(int boardNo) {
		return session.update("board.increaseCount",boardNo);
	}

	@Override
	public BoardExt selectBoard(int boardNo) {
		return session.selectOne("board.selectBoard",boardNo);
	}

	@Override
	public int insertBoard(Board board, List<MultipartFile> upFiles, String savePath) {
		return session.insert("board.insertBoard",board);
	}

	
	@Override
	public int insertAttachFileList(List<AttachFile> attachFileList) {
		return session.insert("board.insertAttachFileList", attachFileList);
	}

	@Override
	public BoardType getBoardTypeMap(String dbGameCode , String boardType) {
		Map<String, String> paramMap = new HashMap<>();
	    paramMap.put("gameCode", dbGameCode);
	    paramMap.put("boardType", boardType); 
	    
	    return session.selectOne("board.getBoardTypeMap", paramMap);
	}


}
