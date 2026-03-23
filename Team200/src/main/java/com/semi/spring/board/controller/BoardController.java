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
<<<<<<< HEAD
	// 게시글 확인 페이지
    @GetMapping("/view")
    public String board_view() {
        return "board/board_view"; 
    }

    // 자유게시판 메인
    @GetMapping("/free")
    public String board_freeMain() {
        return "board/free_main";
    }
    
    // 자유게시판 작성
    @GetMapping("/freewrite")
    public String board_freeWrite() {
        return "board/free_write";
    }

    // 공략게시판 메인
    @GetMapping("/strategy")
    public String board_strategy() {
        return "board/strategy_main";
    }
    
    // 공략게시판 작성
    @GetMapping("/strategywrite")
    public String board_strategyWrite() {
        return "board/strategy_write";
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

	
=======

>>>>>>> parent of bf55e09 (jsp 파일 수정 및 제이쿼리로 변환)
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