package com.semi.spring.board.controller;

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

import com.semi.spring.board.model.vo.Board;
import com.semi.spring.common.model.vo.PageInfo;

import com.semi.spring.board.model.service.BoardService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/board")
public class BoardController {
	
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

	private final BoardService boardService;
	private final ResourceLoader resourceLoader;
	private final ServletContext application; // application scope
	/*
	 * ResourceLoader
	 * - 스프링에서 제공하는 자원 로딩 클래스
	 * - classpath, file시스템, url등 다양한 경로상의 자원을
	 * "동일한" 인터페이스로 로드(입력)하는 메서드를 제공한다.
	 */
	
	// BoardType전역객체 설정
	// - 어플리케이션 전역에서 사용할 수 있는 BoardType 객체 추가
	// - 서버 가동중 1회만 수행되도록 설정
	
	
	
	
//	private final BoardService boardService;
//	private final ResourceLoader resourceLoader;
//	private final ServletContext application; // application scope
//	/*
//	 * ResourceLoader
//	 * - 스프링에서 제공하는 자원 로딩 클래스
//	 * - classpath, file시스템, url등 다양한 경로상의 자원을 
//	 * "동일한" 인터페이스로 로드(입력)하는 메서드를 제공한다.
//	 */
//	
//	// BoardType전역객체 설정
//	// - 어플리케이션 전역에서 사용할 수 있는 BoardType 객체 추가
//	// - 서버 가동중 1회만 수행되도록 설정
//	
//	
//	
//	
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