package com.semi.spring.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.semi.spring.admin.service.AdminService;
import com.semi.spring.board.model.service.BoardService;
import com.semi.spring.board.model.vo.BoardExt;
import com.semi.spring.board.model.vo.Inquiry;
import com.semi.spring.board.model.vo.Notice;
import com.semi.spring.board.model.vo.Patchnote;
import com.semi.spring.board.model.vo.Report;
import com.semi.spring.common.model.vo.PageInfo;
import com.semi.spring.common.template.Pagination;
import com.semi.spring.member.model.vo.Member;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

	private final AdminService adminService;
	private final BoardService boardService;
	private final ResourceLoader resourceLoader;
	private final ServletContext application; 
	
	@GetMapping("/main")
	public String adminMain(Model model) {
		
		List<BoardExt> patchList = boardService.selectMainPatchNotes();
	    model.addAttribute("patchList", patchList);

	    // 2. 최신 공지사항 리스트 조회 (최신순 3개)
	    List<BoardExt> noticeList = boardService.selectMainNotices();
	    model.addAttribute("noticeList", noticeList);
	    
		return "admin/admin_main";
	}
	
	@GetMapping("/inquiry")
	public String adminInquiry(
			@RequestParam(value="cpage", defaultValue="1") int currentPage,
			@RequestParam(value="gameCode", defaultValue="ALL") String gameCode,
	        @RequestParam(value="answerStatus", defaultValue="ALL") String answerStatus,
			Model model) {
		
		// 고객문의 필터
		Map<String, Object> filters = new HashMap<>();
	    filters.put("gameCode", gameCode);
	    filters.put("answerStatus", answerStatus);
		
		PageInfo pi = new PageInfo();
		
		// 1. 전체 회원 수 조회 (DB에서 가져오기)
  	    int listCount = adminService.selectInquiryListCount(filters);
		
	    // 2. 페이징 설정값 변수 선언
	    int pageLimit = 5;    // 하단 페이징바에 표시할 페이지 개수
	    int boardLimit = 10;  // 한 페이지에 보여줄 회원 수
	    
	    // 3. PageInfo 계산 로직
	    int maxPage = (int)Math.ceil((double)listCount / boardLimit);
	    
	    if (maxPage == 0) maxPage = 1;
	    
	    int startPage = (currentPage - 1) / pageLimit * pageLimit + 1;
	    int endPage = startPage + pageLimit - 1;
	    
	    if(endPage > maxPage) endPage = maxPage;
	    
	    pi.setListCount(listCount);
	    pi.setCurrentPage(currentPage);
	    pi.setPageLimit(pageLimit);
	    pi.setBoardLimit(boardLimit);
	    pi.setMaxPage(maxPage);
	    pi.setStartPage(startPage);
	    pi.setEndPage(endPage);
		
		List<Inquiry> list = adminService.selectInquiryList(pi, filters);
		
		model.addAttribute("inquiryList", list);
		model.addAttribute("pi", pi);
		model.addAttribute("gameCode", gameCode); 		
	    model.addAttribute("answerStatus", answerStatus);     
		
		return "admin/admin_inquiry";
	}
	
	// 어드민 전용 마이페이지가 필요한가
	@GetMapping("/mypage")
	public String adminMyPage(
			@ModelAttribute Member member,
			Model model) {
		
		model.addAttribute(member);
		
		return "admin/admin_mypage";
	}
	
	@GetMapping("/notice") // (혹은 매핑해둔 주소)
	public String adminNoticeForm(Model model) {
	    
	    // 1. 공지 등록 폼을 위한 빈 객체
	    model.addAttribute("notice", new Notice());

	    // 2. 왼쪽 사이드바용: 게임별 최신 패치노트 (총 3개)
	    List<BoardExt> recentPatchList = boardService.selectMainPatchNotes();
	    model.addAttribute("recentPatchList", recentPatchList);

	    // 3. 오른쪽 사이드바용: 최근 공지사항 (최신 3~5개)
	    List<BoardExt> recentNoticeList = boardService.selectMainNotices();
	    model.addAttribute("recentNoticeList", recentNoticeList);

	    return "admin/admin_notice";
	}
	
	@PostMapping("/notice")
	public String adminNoticePost(@ModelAttribute Notice notice,
			Model model,
			RedirectAttributes ra){
		
		model.addAttribute(notice);
		
		int result = adminService.insertNotice(notice);
		if(result > 0) {
	        ra.addFlashAttribute("message", "공지사항이 등록되었습니다.");
	    } else {
	        ra.addFlashAttribute("message", "등록 실패!");
	    }
		
		return "redirect:/admin/main";
	}
	
	@GetMapping("/patchnote")
	public String adminPatchnote(Model model) {
	    
	    // 1. 등록 폼을 위한 빈 객체
	    model.addAttribute("patchnote", new Patchnote());

	    // 2. ✨ 최근 등록된 패치노트 리스트 가져오기
	    // (만약 boardService.selectMainPatchNotes()를 쓰면 게임별 최신 1개씩 총 3개가 옵니다)
	    // (또는 공지사항처럼 offset, limit 파라미터를 넘겨 최신순 5개를 가져오는 메서드를 쓰셔도 좋습니다!)
	    List<BoardExt> recentPatchList = boardService.selectMainPatchNotes(); 
	    
	    // 3. 모델에 담아서 JSP로 토스!
	    model.addAttribute("recentPatchList", recentPatchList);

	    return "admin/admin_patchnotes";
	}
	
	@PostMapping("/patchnote")
	public String adminPatchnotePost(@ModelAttribute Patchnote patchnote,
			Model model,
			RedirectAttributes ra) {
		
		model.addAttribute(patchnote);
		
		int result = adminService.insertPatchnote(patchnote);
		if(result > 0) {
	        ra.addFlashAttribute("message", "공지사항이 등록되었습니다.");
	    } else {
	        ra.addFlashAttribute("message", "등록 실패!");
	    }
	
		return "redirect:/admin/main";
	}
			
	
	@GetMapping("/postlist")
	public String adminPostlist(){
		return "admin/admin_postlist";
	}
	
	@GetMapping("/user_report")
	public String userReport(
			@RequestParam(value="type", defaultValue="post") String type,     // post(글), comment(댓글)
	        @RequestParam(value="order", defaultValue="recent") String order, // recent(최신), count(신고많은)
	        @RequestParam(value="currentPage", defaultValue="1") int currentPage,
	        Model model) {
		
		// 1. 전체 게시글 개수 조회 (필터 조건 포함)
	    Map<String, Object> filters = new HashMap<>();
	    filters.put("type", type);
	    
	    int listCount = adminService.getReportListCount(filters); // GROUP BY 된 결과의 총 개수
	    
	    // 2. 페이징 계산 로직 (페이지당 10개씩 보여준다고 가정)
	    // PageInfo는 보통 별도의 클래스로 구현합니다 (아래 설명 참조)
	    PageInfo pi = Pagination.getPageInfo(currentPage, listCount, 10, 5);
		
	    // 3. 해당 페이지의 데이터만 조회
	    List<Report> reportList = adminService.selectReportList(filters, pi, order);
		
	    System.out.println("데이터 확인: " + reportList);
		// 4. 데이터 전달
		model.addAttribute("reportList", reportList);
	    model.addAttribute("pi", pi); // 페이징 정보 (startPage, endPage, maxPage 등)
	    model.addAttribute("type", type);
	    model.addAttribute("order", order);
	    
	    return "admin/user_report";
	}
	
	@GetMapping("/user_management")
	public String userManagement(
			@RequestParam(value="cpage", defaultValue="1") int currentPage,
			@RequestParam(value="keyword", defaultValue="") String keyword,
	        @RequestParam(value="order", defaultValue="date") String order,
	        @RequestParam(value="withdraw", defaultValue="ALL") String withdraw,
			Model model) {
		
		Map<String, Object> filters = new HashMap<>();
	    filters.put("keyword", keyword);
	    filters.put("order", order);
	    filters.put("withdraw", withdraw); // Key 변경
		
	    int listCount = adminService.selectMemberListCount(filters);
		PageInfo pi = new PageInfo();
		// 1. 전체 회원 수 조회 (DB에서 가져오기)
		
	    // 2. 페이징 설정값 변수 선언
	    int pageLimit = 5;    // 하단 페이징바에 표시할 페이지 개수
	    int boardLimit = 10;  // 한 페이지에 보여줄 회원 수
	    
	 // 3. PageInfo 계산 로직
	    int maxPage = (int)Math.ceil((double)listCount / boardLimit);
	    
	    if (maxPage == 0) maxPage = 1;
	    
	    int startPage = (currentPage - 1) / pageLimit * pageLimit + 1;
	    int endPage = startPage + pageLimit - 1;
	    
	    if(endPage > maxPage) endPage = maxPage;
	    
	    pi.setListCount(listCount);
	    pi.setCurrentPage(currentPage);
	    pi.setPageLimit(pageLimit);
	    pi.setBoardLimit(boardLimit);
	    pi.setMaxPage(maxPage);
	    pi.setStartPage(startPage);
	    pi.setEndPage(endPage);
		
		List<Member> userList = adminService.selectMemberList(pi , filters);
		
		model.addAttribute("userList", userList);
		model.addAttribute("pi", pi);
		model.addAttribute("keyword", keyword);
	    model.addAttribute("order", order);
	    model.addAttribute("withdraw", withdraw);
		return "admin/user_management";
	}
	
	@ResponseBody
	@PostMapping("/deleteUser")
	public String deleteUser(int userNo) {
		
		int userList = adminService.deleteMember(userNo);
		return (userList > 0) ? "success" : "fail";
	}
	
	@GetMapping("/deleteContent")
	public String deleteContent(String type, int no, RedirectAttributes ra) {
	    // type: "post" 또는 "comment"
	    // no: boardNo 또는 replyNo
	    
	    int result = adminService.deleteContent(type, no);
	    
	    if (result > 0) {
	        ra.addFlashAttribute("alertMsg", "콘텐츠 삭제 및 관련 신고 처리가 완료되었습니다.");
	    } else {
	        ra.addFlashAttribute("alertMsg", "삭제 처리 중 오류가 발생했습니다.");
	    }
	    
	    // 처리가 끝나면 다시 신고 리스트 페이지로 리다이렉트
	    return "redirect:/admin/user_report?type=" + type;
	}
	
	@ResponseBody
	@PostMapping("/updateUserWithdraw")
	public String updateUserWithdraw(int userNo, String withdraw) {
		
		String withdrawValue = "N"; 
		if ("Y".equalsIgnoreCase(withdraw) || "정지".equals(withdraw)) {
	        withdrawValue = "Y";
	    } else {
	        withdrawValue = "N";
	    }
		
	    int result = adminService.updateUserWithdraw(userNo, withdrawValue);
	    
	    // AJAX의 success 반환
	    return (result > 0) ? "success" : "fail";
	}
	
	@PostMapping("/insertAnswer")
	@ResponseBody // AJAX 응답을 위해 필수
	public String insertAnswer(@RequestParam("boardNo") int boardNo, 
	                           @RequestParam("answerContent") String answer) {
	    
		System.out.println("넘어온 번호: " + boardNo);
	    System.out.println("넘어온 내용: " + answer);
	    // 비즈니스 로직 실행
	    int result = adminService.insertAnswer(boardNo, answer);
	    System.out.println("DB 결과(행 개수): " + result); // 여기서 0이 나오면 조건절(WHERE) 문제임
	    // 성공 시 "success" 문자열 반환
	    return (result > 0) ? "success" : "fail";
	}
	
	
}
