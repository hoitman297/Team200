package com.semi.spring;

import java.util.List;
import java.util.Locale;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.semi.spring.board.model.service.BoardService; 
import com.semi.spring.board.model.vo.BoardExt;

@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	// ✨ 1. 보드 서비스를 주입받습니다.
	@Autowired
	private BoardService boardService;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		
		logger.info("통합 메인 페이지(HomeController) 진입 성공!");

		List<BoardExt> bestList = boardService.selectBestBoards("ALL");
		
		System.out.println(">>> [HomeController] 가져온 인기글 개수: " + (bestList != null ? bestList.size() : 0));
		
		// 2. 패치노트: 각 게임별 최신 1개씩 (총 3개)
		List<BoardExt> patchList = boardService.selectMainPatchNotes();
		model.addAttribute("patchList", patchList);

		// 3. 공지사항: 최신순 3개
		List<BoardExt> noticeList = boardService.selectMainNotices();
		model.addAttribute("noticeList", noticeList);
				
		System.out.println("패치노트 데이터 개수: " + (patchList != null ? patchList.size() : 0));
		System.out.println("공지사항 데이터 개수: " + (noticeList != null ? noticeList.size() : 0));
				
		model.addAttribute("bestList", bestList);
		model.addAttribute("lolBest", boardService.selectBestBoards("LOL"));
	    model.addAttribute("owBest", boardService.selectBestBoards("OW"));
	    model.addAttribute("bgBest", boardService.selectBestBoards("BG"));
	    
		return "mainpage";
	}
	
	@GetMapping("/{gameCode}/main")
	public String gameMainPage(@PathVariable("gameCode") String gameCode, Model model) {
	    
	    String dbGameCode = "";
	    String lowerCode = gameCode.toLowerCase();
	    
	    switch(lowerCode) {
	        case "lol": dbGameCode = "LOL"; break;
	        case "bg": 
	        case "battleground": dbGameCode = "BG"; break;
	        case "ow": 
	        case "overwatch": dbGameCode = "OW"; break;
	        default: dbGameCode = gameCode.toUpperCase();
	    }
	    
	    List<BoardExt> bestList = boardService.selectBestBoards(dbGameCode);
	    model.addAttribute("bestList", bestList);
	    
	    List<BoardExt> recentGallery = boardService.selectRecentGallery(dbGameCode);
	    model.addAttribute("recentGallery", recentGallery);
	    
	    List<BoardExt> patchList = boardService.selectRecentPatchNotesByGame(dbGameCode);
	    model.addAttribute("patchList", patchList);
	    
	    model.addAttribute("gameId", lowerCode);
	    
	    String viewPath = "";
	    switch(lowerCode) {
	        case "lol": 
	            viewPath = "lol/lol_main"; 
	            break;
	        case "ow": 
	        case "overwatch": 
	            viewPath = "overwatch/overwatch_main"; 
	            break;
	        case "bg": 
	        case "battleground": 
	            viewPath = "battleground/battle_main"; 
	            break;
	        default: 
	            viewPath = lowerCode + "/" + lowerCode + "_main"; // 기본 규칙
	    }
	    
	    System.out.println(">>> [" + dbGameCode + "] 메인 진입 - 이동경로: " + viewPath);
	    
	    return viewPath;
	}
	
	
}