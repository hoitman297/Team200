package com.semi.spring.overwatch.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.semi.spring.board.model.service.BoardService;
import com.semi.spring.board.model.vo.Board;
import com.semi.spring.common.model.vo.PageInfo;
import com.semi.spring.common.template.Pagination;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/overwatch") 
@Slf4j
@RequiredArgsConstructor
public class OverwatchController {
	
	private final BoardService boardService;
	private final ResourceLoader resourceLoader;
	private final ServletContext application;
	
	@GetMapping("/main")
	public String overwatch_main() {
		return "overwatch/overwatch_main";
	}
	
	@GetMapping("/board/{categoryNo}")
	// categoryNo = 자유 게시판 (N?) , 공략 게시판(S?)
	public String overwatchBoard(
			@PathVariable("categoryNo") String categoryNo ,
			@RequestParam(value = "currentPage", defaultValue = "1") int currentPage ,
			Model model,
			@RequestParam Map<String, Object> paramMap
			) {
		
		paramMap.put("categoryNo", categoryNo);
		
		int boardLimit = 10;
		int pageLimit = 10;
		int listCount = boardService.selectListCount(paramMap);
		
		PageInfo pi =
				Pagination
				.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
		log.debug("pi : {}",pi);
		paramMap.put("pi", pi);
		
		List<Board> list = boardService.selectList(paramMap);
		model.addAttribute("list",list);
		model.addAttribute("pi",pi);
		
		return null; // overwatch/board/{categoryNo}?currentPage=1
	}
	
	@GetMapping("/hero")
	public String overwatch_hero() {
		return "overwatch/overwatch_hero_info";
	}
	
	@GetMapping("/box")
	public String overwatch_box() {
		return "overwatch/box"; 
	}
	
}
