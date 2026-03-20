package com.semi.spring.board.model.service;

import java.util.List;
import java.util.Map;

import com.semi.spring.board.model.vo.Board;

public interface BoardService {

	int selectListCount(Map<String, Object> paramMap);

	List<Board> selectList(Map<String, Object> paramMap);

}
