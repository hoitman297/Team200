package com.semi.spring.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

import org.springframework.core.io.ResourceLoader;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.semi.spring.board.model.service.BoardService;
import com.semi.spring.board.model.vo.Board;
import com.semi.spring.board.model.vo.BoardExt;
import com.semi.spring.board.model.vo.BoardType;
import com.semi.spring.common.model.vo.PageInfo;
import com.semi.spring.common.template.Pagination;
import com.semi.spring.security.model.vo.MemberExt;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/board")
public class BoardController {
	
	private final BoardService boardService;
	private final ResourceLoader resourceLoader;
	private final ServletContext application; // application scope

    // 문의 메인
    @GetMapping("/inquiry")
    public String board_inquiry() {
        return "board/user_inquiry";
    }
    
    // 문의 작성
    @GetMapping("/inquiryWrite")
    public String board_inquiryWrite() {
        return "board/user_inquiry_write";
    }
	
	@GetMapping("/view")
	public String board_view(
	        @RequestParam("boardNo") int boardNo,
	        Model model) {
	    
	    boardService.increaseCount(boardNo);
	    BoardExt board = boardService.selectBoard(boardNo);
	    
	    if (board == null) {
	        return "redirect:/";
	    }
	    
	    model.addAttribute("board", board);
	    return "board/board_view";
	}
		
	//공통
	private void addBoardListToModel(Map<String, Object> paramMap, int cp, Model model) {
	    int listCount = boardService.selectListCount(paramMap); //
	    PageInfo pi = Pagination.getPageInfo(listCount, cp, 10, 10); //
	    paramMap.put("pi", pi);
	    
	    List<Board> list = boardService.selectList(paramMap); //
	    
	    model.addAttribute("boardList", list);
	    model.addAttribute("pi", pi);
	}

	
	// 글 타입별 게임별 자유게시판
	@GetMapping("/free_{gameCode}")
	public String freeGame(
						@PathVariable("gameCode") String gameCode,
						@RequestParam(value="cp", defaultValue="1") int cp,
						@RequestParam Map<String, Object> paramMap,
						Model model) {

		String dbGameCode = "";
		
		switch(gameCode.toLowerCase()) {
        case "battleground": dbGameCode = "BG"; break;
        case "overwatch":    dbGameCode = "OW"; break;
        case "lol":          dbGameCode = "LOL"; break;
        default:             dbGameCode = gameCode.toUpperCase();
    }
		
		BoardType gameConfig = boardService.getBoardTypeMap(dbGameCode , "자유");
		
		if (gameConfig == null) {
	        return "common/error";
	    }
		
		paramMap.put("gameCode", dbGameCode);
	    paramMap.put("categoryNo", gameConfig.getCategoryNo());

	    String safeGameId = gameCode.toLowerCase().equals("battleground") ? "bg" : 
            				gameCode.toLowerCase().equals("overwatch") ? "ow" : "lol";
	    
	    model.addAttribute("gameId", safeGameId);
	    model.addAttribute("gameName", gameConfig.getCategoryName());
	    
	    addBoardListToModel(paramMap, cp, model);
		
		return "board/free_main_" + gameCode;
	}
		
	// 게임별 자유게시판 작성 페이지
	@GetMapping("/free_write_{gameCode}")
	public String freeWriteGame(
			@PathVariable("gameCode") String gameCode,
			HttpSession session, 
			Model model) {
		
		String dbGameCode = "";
	    switch(gameCode.toLowerCase()) {
	        case "battleground": dbGameCode = "BG"; break;
	        case "overwatch":    dbGameCode = "OW"; break;
	        case "lol":          dbGameCode = "LOL"; break;
	        default:             dbGameCode = gameCode.toUpperCase();
	    }
	    
	    BoardType gameConfig = boardService.getBoardTypeMap(dbGameCode, "자유");
	    
	    if (gameConfig == null) {
	        return "common/error";
	    }
	    
		session.setAttribute("tempGameCode", dbGameCode); //
	    session.setAttribute("tempCategoryNo", gameConfig.getCategoryNo());
	    session.setAttribute("tempBoardType", "free");

	    String safeGameId = gameCode.toLowerCase().equals("battleground") ? "bg" : 
	    					gameCode.toLowerCase().equals("overwatch") ? "ow" : "lol";
	   	model.addAttribute("gameId", safeGameId);
	    model.addAttribute("gameName", gameConfig.getCategoryName());

		return "board/free_write_" + gameCode;
	}
	
	// 게임별 공략 게시판
	@GetMapping("/strategy_{gameCode}")
	public String strategyGame(
						@PathVariable("gameCode") String gameCode,
						@RequestParam(value="cp", defaultValue="1") int cp,
						@RequestParam Map<String, Object> paramMap,
						Model model) {

		String dbGameCode = "";
		
		switch(gameCode.toLowerCase()) {
        case "battleground": dbGameCode = "BG"; break;
        case "overwatch":    dbGameCode = "OW"; break;
        case "lol":          dbGameCode = "LOL"; break;
        default:             dbGameCode = gameCode.toUpperCase();
    }
		
		BoardType gameConfig = boardService.getBoardTypeMap(dbGameCode , "공략");
		
		if (gameConfig == null) {
	        return "common/error";
	    }
		
		paramMap.put("gameCode", dbGameCode);
	    paramMap.put("categoryNo", gameConfig.getCategoryNo());

	    String safeGameId = gameCode.toLowerCase().equals("battleground") ? "bg" : 
            				gameCode.toLowerCase().equals("overwatch") ? "ow" : "lol";
	    
	    model.addAttribute("gameId", safeGameId);
	    model.addAttribute("gameName", gameConfig.getCategoryName());
	    
	    addBoardListToModel(paramMap, cp, model);
		
		return "board/strategy_main_" + gameCode;
	}

	
	// 게임별 공략게시판 작성 페이지
	@GetMapping("/strategy_write_{gameCode}")
	public String strategyWriteGame(
			@PathVariable("gameCode") String gameCode,
			HttpSession session, 
			Model model) {
		
		String dbGameCode = "";
	    switch(gameCode.toLowerCase()) {
	        case "battleground": dbGameCode = "BG"; break;
	        case "overwatch":    dbGameCode = "OW"; break;
	        case "lol":          dbGameCode = "LOL"; break;
	        default:             dbGameCode = gameCode.toUpperCase();
	    }
	    
	    BoardType gameConfig = boardService.getBoardTypeMap(dbGameCode, "공략");
	    
	    if (gameConfig == null) {
	        return "common/error";
	    }
	    
		session.setAttribute("tempGameCode", dbGameCode); //
	    session.setAttribute("tempCategoryNo", gameConfig.getCategoryNo());
	    session.setAttribute("tempBoardType", "strategy");

	    String safeGameId = gameCode.toLowerCase().equals("battleground") ? "bg" : 
	    					gameCode.toLowerCase().equals("overwatch") ? "ow" : "lol";
	   	model.addAttribute("gameId", safeGameId);
	    model.addAttribute("gameName", gameConfig.getCategoryName());

		return "board/strategy_write_" + gameCode;
	}	
	
	// 통합 글 작성
		@PostMapping("/{boardType}_write_{gameCode}")
		public String insertBoard(
				@PathVariable("boardType") String boardType, // URL에서 온 "free" 또는 "strategy"
		        @PathVariable("gameCode") String gameCode,   // URL에서 온 "lol", "bg" 등
		        Board board,
		        @RequestParam("title") String title,     
		        @RequestParam("content") String content, 
		        @RequestParam(value="upFile", required=false) List<MultipartFile> upFiles,
		        Authentication auth,
		        HttpSession session, 
		        RedirectAttributes ra) {
			
			if (auth == null || !auth.isAuthenticated()) {
		        ra.addFlashAttribute("message", "로그인 후 이용 가능합니다.");
		        return "redirect:/member/login";
		    }

			String tempGameCode = (String) session.getAttribute("tempGameCode");     // DB용 "LOL"
		    Integer tempCategoryNo = (Integer) session.getAttribute("tempCategoryNo"); // 카테고리 번호
			
		    if (tempGameCode == null || tempCategoryNo == null) {
		        ra.addFlashAttribute("message", "작성 시간이 만료되었거나 잘못된 접근입니다.");
		        return "redirect:/";
		    }
			
			MemberExt loginUser = (MemberExt)auth.getPrincipal();
			
			board.setUserNo(loginUser.getUserNo());
			board.setBoardTitle(title);    
		    board.setBoardContent(content); 
		    board.setGameCode(tempGameCode);     // 세션에서 꺼낸 대문자 게임코드
		    board.setCategoryNo(tempCategoryNo); // 세션에서 꺼낸 정확한 카테고리 번호
		    
		    String savePath = session.getServletContext().getRealPath("/resources/upload/board/");
		    
		    int result = boardService.insertBoard(board, upFiles, savePath);
		    
		    session.removeAttribute("tempGameCode");
		    session.removeAttribute("tempCategoryNo");
		    session.removeAttribute("tempBoardType");

		    if(result > 0) {
		        ra.addFlashAttribute("message", "게시글이 성공적으로 등록되었습니다.");
		        return "redirect:/board/" + boardType + "_" + gameCode;
		    } else {
		        ra.addFlashAttribute("message", "게시글 등록에 실패했습니다.");
		        return "redirect:/";
		    }
		}
}