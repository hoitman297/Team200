package com.semi.spring.lol.controller;

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
import com.semi.spring.lol.model.service.LolService;
import com.semi.spring.lol.model.vo.ChampionVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/lol") 
@Slf4j
@RequiredArgsConstructor
public class LolController {
	private LolService lolService;
	private final BoardService boardService;
	private final ResourceLoader resourceLoader;
	private final ServletContext application;
	
	@GetMapping("/main")
	public String lol_main() {
		return "lol/lol_main";
	}
	
	@GetMapping("/board/{categoryNo}")
	// categoryNo = 자유 게시판 (N?) , 공략 게시판(S?)
	public String lolBoard(
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
		
		return "/board/board_view";  // lol/board/{categoryNo}?currentPage=1
		// 아직 수정중
	}
	
	@GetMapping("/hero")
	public String lol_hero(Model model) {
		// 1. DB에서 챔피언 리스트 가져오기
        List<ChampionVO> champList = lolService.selectAllChampions();
        
        // 2. JSP로 데이터 전달
        model.addAttribute("champList", champList);
        
        // 3. 롤 페이지(JSP) 리턴
        return "lol/main";
	}
	
	@GetMapping("/item")
	public String lol_item() {
		return "lol/lol_item_info";
	}
	
	@GetMapping("/rune")
	public String lol_rune() {
		return "lol/lol_rune_info";
	}
	
	@GetMapping("/box")
	public String lol_box() {
		return "lol/box";
	}
	
}
