package com.semi.spring.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
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
	
<<<<<<< HEAD
//    @GetMapping("/view")
//    public String board_view() {
//        return "board/board_view"; 
//    }
//    
//    // 자유게시판 작성 배그
//    @GetMapping("/free_write_battleground")
//    public String freeWriteBattleground() {
//        return "board/free_write_battleground";
//    }
//    // 자유게시판 작성 롤
//    @GetMapping("/free_write_lol")
//    public String freeWriteLol() {
//        return "board/free_write_lol";
//    }
//    // 자유게시판 작성 옵치
//    @GetMapping("/free_write_overwatch")
//    public String freeWriteOverwatch() {
//        return "board/free_write_overwatch";
//    }
        
//    // 공략게시판 작성 배그
//    @GetMapping("/strategy_write_battleground")
//    public String strategyWriteBattleground() {
//        return "board/strategy_write_battleground";
//    }
//    // 공략게시판 작성 롤
//    @GetMapping("/strategy_write_lol")
//    public String strategyWriteLol() {
//        return "board/strategy_write_lol";
//    }
//    // 공략게시판 작성 옵치
//    @GetMapping("/strategy_write_overwatch")
//    public String strategyWriteOverwatch() {
//        return "board/strategy_write_overwatch";
//    }
=======
	// 게시글 목록 확인 페이지
    @GetMapping("/view")
    public String board_view() {
        return "board/board_view"; 
    }

    
    // 자유게시판 메인 배그
    @GetMapping("/free_battleground")
    public String freeBattleground() {
        return "board/free_main_battleground";
    }
    // 자유게시판 메인 롤
    @GetMapping("/free_lol")
    public String freeLol() {
        return "board/free_main_lol";
    }
    // 자유게시판 메인 옵치
    @GetMapping("/free_overwatch")
    public String freeOverwatch() {
        return "board/free_main_overwatch";
    }
    
    
    // 자유게시판 작성 배그
    @GetMapping("/free_write_battleground")
    public String freeWriteBattleground() {
        return "board/free_write_battleground";
    }
    // 자유게시판 작성 롤
    @GetMapping("/free_write_lol")
    public String freeWriteLol() {
        return "board/free_write_lol";
    }
    // 자유게시판 작성 옵치
    @GetMapping("/free_write_overwatch")
    public String freeWriteOverwatch() {
        return "board/free_write_overwatch";
    }

    
    
    // 공략게시판 메인 배그
    @GetMapping("/strategy_battleground")
    public String strategyBattleground() {
        return "board/strategy_main_battleground";
    }
    // 공략게시판 메인 롤
    @GetMapping("/strategy_lol")
    public String strategyLol() {
        return "board/strategy_main_lol";
    }
    // 공략게시판 메인 옵치
    @GetMapping("/strategy_overwatch")
    public String strategyOverwatch() {
        return "board/strategy_main_overwatch";
    }
    
    
    // 공략게시판 작성 배그
    @GetMapping("/strategy_write_battleground")
    public String strategyWriteBattleground() {
        return "board/strategy_write_battleground";
    }
    // 공략게시판 작성 롤
    @GetMapping("/strategy_write_lol")
    public String strategyWriteLol() {
        return "board/strategy_write_lol";
    }
    // 공략게시판 작성 옵치
    @GetMapping("/strategy_write_overwatch")
    public String strategyWriteOverwatch() {
        return "board/strategy_write_overwatch";
    }
    
    
>>>>>>> main
    
	private final BoardService boardService;
	private final ResourceLoader resourceLoader;
	private final ServletContext application; // application scope
	
	@PostConstruct
	public void init() {
		
		// CATEGORY_NO, gameCode(lol,bg,ow)
		//Map<Integer , String> categoryTableMap= new HashMap<>();
	
		//categoryTableMap = boardService.getCategoryTableMap(String gameCode);
	
		//application.setAttribute("categoryTableMap", categoryTableMap);
		//log.debug("categoryTableMap : {}" , categoryTableMap);
	}
	
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
		@GetMapping("/{boardType}/{gameCode}")
		public String typeGame(
				@PathVariable("boardType") String boardType ,
				@PathVariable("gameCode") String gameCode ,
				@RequestParam(value="cp", defaultValue="1") int cp,
				Model model) {
			
			
			
		
			// Integer = categoryNo , String = gameName
			Map<String, Object> gameConfig = boardService.getCategoryTableMap(gameCode.toUpperCase());
			
			Map<String, Object> boardTypeMap = boardService.getBoardTypeMap(boardType);
			
			if (gameConfig == null || boardTypeMap == null) {
		        return "common/error";
		    }
			
			boardType = (String)boardTypeMap.get(boardType);
			String categoryNo = (String)gameConfig.get("categoryNo");
			
		    Map<String, Object> paramMap = new HashMap<>();
		    paramMap.put("boardType", boardType);
			paramMap.put("gameCode", gameCode.toLowerCase());
		    paramMap.put("categoryNo", categoryNo);

		    model.addAttribute("boardType", boardType);
		    model.addAttribute("gameCode", gameCode.toLowerCase());
		    
		    addBoardListToModel(paramMap, cp, model);
			
			return "board/free_main";
		}
		
	// 글 타입별 게임별 자유게시판
	@GetMapping("/free/{gameCode}")
	public String freeGame(@PathVariable("gameCode") String gameCode
						,@RequestParam(value="cp", defaultValue="1") int cp,
						Model model) {
		
		Map<String, Object> paramMap = new HashMap<>();
		String gameName = "";
		String categoryNo = "";
		
		// Integer = categoryNo , String = gameName
		Map<String, Object> gameConfig = boardService.getCategoryTableMap(gameCode.toUpperCase());
		
		if (gameConfig == null) {
	        return "common/error";
	    }
		
		categoryNo = (String)gameConfig.get(categoryNo);
	    gameName = (String)gameConfig.get("gameName");
	    
		paramMap.put("gameCode", gameCode);
	    paramMap.put("categoryNo", categoryNo);

	    model.addAttribute("gameCode", gameCode.toLowerCase());
	    addBoardListToModel(paramMap, cp, model);
		
		return "board/free_main";
	}
	
//	// 게임별 공략 게시판
//	@GetMapping("/strategy/{gameCode}")
//	public String strategyGame(@PathVariable("gameCode") String gameCode
//						,@RequestParam(value="cp", defaultValue="1") int cp,
//						Model model) {
//			
//			Map<String, Object> paramMap = new HashMap<>();
//			String gameName = "";
//			String categoryNo = "";
//			
//			// Integer = categoryNo , String = gameName
//			Map<String, Object> gameConfig = boardService.getCategoryTableMap(gameCode.toUpperCase());
//			
//			if (gameConfig == null) {
//		        return "common/error";
//		    }
//			
//			categoryNo = (String)gameConfig.get(categoryNo);
//		    gameName = (String)gameConfig.get("gameName");
//		    
//			paramMap.put("gameCode", gameCode);
//		    paramMap.put("categoryNo", categoryNo);
//
//		    model.addAttribute("gameCode", gameCode.toLowerCase());
//		    addBoardListToModel(paramMap, cp, model);
//			
//			return "board/strategy_main";
//	}
		
	// 게임별 자유게시판 작성 페이지
	@GetMapping("/free/write/{gameCode}")
	public String freeWriteGame(HttpSession session, 
			@PathVariable("gameCode") String gameCode,
			Model model) {
		
		Map<String, Object> paramMap = new HashMap<>();
		String gameName = "";
		String categoryNo = "";
		
		// Integer = categoryNo , String = gameName
		Map<String, Object> gameConfig = boardService.getCategoryTableMap(gameCode.toUpperCase());
		
		if (gameConfig == null) {
	        return "common/error";
	    }
		
		categoryNo = (String)gameConfig.get(categoryNo);
	    gameName = (String)gameConfig.get("gameName");
		
		session.setAttribute("tempGameCode", gameCode.toUpperCase()); //
	    session.setAttribute("tempCategoryNo", categoryNo);
	    session.setAttribute("tempBoardType", "free");

		return "board/free_write";
	}
	
	// 게임별 공략게시판 작성 페이지
		@GetMapping("/strategy/write/{gameCode}")
		public String strategyWriteGame(HttpSession session, 
				@PathVariable("gameCode") String gameCode,
				Model model) {
			
			Map<String, Object> paramMap = new HashMap<>();
			String gameName = "";
			String categoryNo = "";
			
			// Integer = categoryNo , String = gameName
			Map<String, Object> gameConfig = boardService.getCategoryTableMap(gameCode.toUpperCase());
			
			if (gameConfig == null) {
		        return "common/error";
		    }
			
			categoryNo = (String)gameConfig.get(categoryNo);
		    gameName = (String)gameConfig.get("gameName");
			
			session.setAttribute("tempGameCode", gameCode.toUpperCase()); //
		    session.setAttribute("tempCategoryNo", categoryNo);
		    session.setAttribute("tempBoardType", "free");

			return "board/strategy_write";
		}
	
	// 글 작성
		@PostMapping("/free/write/{gameCode}")
		public String insertBoard(
				@PathVariable("gameCode") String gameCode,
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

			MemberExt loginUser = (MemberExt)auth.getPrincipal();
			
			board.setUserNo(loginUser.getUserNo());
			board.setBoardTitle(title);    
		    board.setBoardContent(content); 
			
		    String boardType = (String) session.getAttribute("tempBoardType"); 
		    if (boardType == null) boardType = "free";
		    
		    String tempGameCode = (String) session.getAttribute("tempGameCode");
		    Integer tempCategoryNo = (Integer) session.getAttribute("tempCategoryNo");

		    if (tempGameCode == null || tempCategoryNo == null) {
		        ra.addFlashAttribute("message", "잘못된 접근입니다. 다시 시도해주세요.");
		        return "redirect:/";
		    }

		    board.setGameCode(tempGameCode);
		    board.setCategoryNo(tempCategoryNo);
		    
		    String savePath = session.getServletContext().getRealPath("/resources/upload/board/");
		    
		    int result = boardService.insertBoard(board, upFiles, savePath);
		    
		    session.removeAttribute("tempGameCode");
		    session.removeAttribute("tempCategoryNo");
		    session.removeAttribute("tempBoardType");
		    
		    String redirectGame;
		    switch (board.getGameCode()) {
		        case "BG": redirectGame = "battleground"; break;
		        case "OW": redirectGame = "overwatch";    break;
		        default:   redirectGame = "lol";          break;
		    }
		 
		    if(result > 0) {
		        ra.addFlashAttribute("message", "게시글이 성공적으로 등록되었습니다.");
		        return "redirect:/board/" + boardType + "_" + redirectGame;
		    } else {
		        ra.addFlashAttribute("message", "게시글 등록에 실패했습니다.");
		        return "redirect:/";
		    }
		}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
//	private final BoardService boardService;
//	private final ResourceLoader resourceLoader;
//	private final ServletContext application; // application scope
	/*
	 * ResourceLoader
	 * - 스프링에서 제공하는 자원 로딩 클래스
	 * - classpath, file시스템, url등 다양한 경로상의 자원을
	 * "동일한" 인터페이스로 로드(입력)하는 메서드를 제공한다.
	 */
	
	// BoardType전역객체 설정
	// - 어플리케이션 전역에서 사용할 수 있는 BoardType 객체 추가
	// - 서버 가동중 1회만 수행되도록 설정
	
//	/*
//	
//	@GetMapping("/list/{boardCode}") 
//	public String selectList(
//			@PathVariable("boardCode") String boardCode
//			/*
//			 * @PathVariable
//			 * - lol , ow , bg로 바인딩
//			 * - 선언한 동적 경로 변수는 @Pathvariable로 추출하여 사용할 수 있다
//			 * - @PathVariable로 추출한 자원은 자동으로 model영역에 추가된다
//			 */
//			@RequestParam(value="page" , defaultValue = "1") int currentPage,
//			// 현재 요청한 페이지 번호, 기본값을 1로 처리하여 값을 전달하지 않은 경우 항상
//			// 1페이지를 요청하도록 처리하였음
//			Model model ,
//			@RequestParam Map<String, Object> paramMap
//			/*
//			 * @RequestParam Map<String, Object>
//			 * - 클라이언트가 전달한 파라미터의 key, value값을 Map형태로 만들어 바인딩
//			 * - 현재 메서드로 전달할 파라미터의 개수가 "정해지지 않은 경우" 혹은 일반적인
//			 * VO 클래스로 바인딩되지 않는 경우 사용한다. (검색파라미터)
//			 * - 반드시 @RequestParam을 추가해줘야 바인딩해준다
//			 */
//			) {
//		/*
//		 * 비지니스 로직
//		 * 1. 페이징처리
//		 *	 	1) 현재 요청한 게시판 코드와 검색정보와 일치하는 게시글의 "총 개수" 조회
//		 * 2) 게시글 갯수, 페이지 번호, 기본 파라미터들을 추출하여 페이징 정보를 가진 객체 생성
//		 * 2. 현재 요청한 게시판 코드와 일치하면서, 현재 요청한 페이지에 맞는 게시글 정보를 조회
//		 * 3. 게시글 정보, 페이징 정보, 검색 정보를 담아서 forward
//		 */
//		// paramMap안에 데이터 조회에 필요한 모든 정보 저장
//		paramMap.put("boardCd", boardCode);
//		
//		int boardLimit = 10;
//		int pageLimit = 10;
//		int listCount = boardService.selectListCount(paramMap);
//		
//		PageInfo pi =
//				Pagination
//				.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
//		log.debug("pi : {}",pi);
//		paramMap.put("pi", pi);
//		
//		List<Board> list = boardService.selectList(paramMap);
//		model.addAttribute("list",list);
//		model.addAttribute("pi",pi);
//		
//		return "board/boardListView";
//	}
//	
//	*/
}