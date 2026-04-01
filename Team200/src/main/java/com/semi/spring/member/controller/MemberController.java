package com.semi.spring.member.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.semi.spring.board.model.service.BoardService;
import com.semi.spring.board.model.vo.BoardExt;
import com.semi.spring.common.model.vo.PageInfo;
import com.semi.spring.common.template.Pagination;
import com.semi.spring.member.model.vo.Member;
import com.semi.spring.member.service.MemberService;
import com.semi.spring.security.model.vo.MemberExt;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/member")
@SessionAttributes({"loginUser"})
public class MemberController {
	
	private final BoardService boardService;
	
	@Autowired
	private BCryptPasswordEncoder passwordEncoder;
	
	@Autowired 
	private MemberService memberService;
	
	// 마이페이지 (수정본)
	@GetMapping("/mypage")
	public String MemberMypage(Authentication auth, Model model) { // Authentication과 Model 추가!
	    
	    // 1. 로그인한 유저 정보 가져오기
	    if (auth == null) return "redirect:/member/login";
	    int userNo = ((MemberExt) auth.getPrincipal()).getUserNo();

	    // 2. 전체 개수를 조회하기 위한 파라미터 세팅
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("userNo", userNo);

	    // 3. ✨ 드디어 숫자를 가져옵니다! (활동내역에서 썼던 그 서비스 호출)
	    int totalBoardCount = boardService.selectMyBoardsCount(paramMap);
	    int totalReplyCount = boardService.selectMyRepliesCount(paramMap);

	    // 4. ✨ 상자(Model)에 담아서 JSP로 보냅니다.
	    model.addAttribute("totalBoardCount", totalBoardCount);
	    model.addAttribute("totalReplyCount", totalReplyCount);

	    return "member/user_mypage";
	}
	
	// 회원정보 수정
	@GetMapping("/update")
	public String MemberUpdate(Model model) {
		model.addAttribute("member", new Member());
		return "member/user_update";
	}
	
	// =================================================================
    // [마이페이지] 나의 활동 내역 (게시글/댓글 탭)
    // =================================================================
	
	// 게임코드 변환 헬퍼 메서드
		private String getDbGameCode(String gameCode) {
		    if (gameCode == null) return "all";
		    
		    // 무조건 대문자로 바꿔서 비교
		    switch(gameCode.toUpperCase()) {
		        case "BATTLEGROUND":
		        case "BG":
		            return "BG";
		        case "OVERWATCH":
		        case "OW":
		            return "OW";
		        case "LOL":
		        case "LEAGUEOFLEGENDS":
		            return "LOL";	
		        case "ALL":
		            return "all";
		        default:
		            return gameCode.toUpperCase();
		    }
		}
		
    @GetMapping("/activity")
    public String myActivity(
            @RequestParam(value="type", defaultValue="board") String type, // 탭 종류 (board 또는 reply)
            @RequestParam(value="game", defaultValue="all") String game,   // 게임 필터 (전체/롤/배그/옵치)
            @RequestParam(value="cp", defaultValue="1") int cp,
            Authentication auth, 
            Model model) {

        // 1. 로그인 체크 및 유저 번호 가져오기
        if (auth == null) {
            return "redirect:/member/login";
        }
        int userNo = ((MemberExt) auth.getPrincipal()).getUserNo();

        // 2. 쿼리에 넘겨줄 파라미터 맵 세팅
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("userNo", userNo);
        
        String dbGameCode = game.equalsIgnoreCase("all") ? "all" : getDbGameCode(game);
        paramMap.put("gameCode", dbGameCode);

        // 3. 탭(type)에 따른 데이터 조회 분기
        if (type.equals("board")) {
            // [작성한 게시글] 탭일 때
            int listCount = boardService.selectMyBoardsCount(paramMap);
            PageInfo pi = Pagination.getPageInfo(listCount, cp, 10, 10);
            List<BoardExt> list = boardService.selectMyBoards(pi, paramMap);
            
            model.addAttribute("list", list);
            model.addAttribute("pi", pi);
            
        } else if (type.equals("reply")) {
            // [작성한 댓글] 탭일 때 (맵 리스트로 받습니다!)
            int listCount = boardService.selectMyRepliesCount(paramMap);
            PageInfo pi = Pagination.getPageInfo(listCount, cp, 10, 10);
            List<Map<String, Object>> list = boardService.selectMyReplies(pi, paramMap);
            
            model.addAttribute("list", list);
            model.addAttribute("pi", pi);
        }

        // 4. 우측 상단 '총 개수'를 위한 별도 조회 (이건 필터 상관없이 항상 전체 개수를 보여줘야 함)
        Map<String, Object> totalParam = new HashMap<>();
        totalParam.put("userNo", userNo);
        totalParam.put("gameCode", "all"); // 게임 필터 무시하고 전체 개수 조회
        
        model.addAttribute("totalBoardCount", boardService.selectMyBoardsCount(totalParam));
        model.addAttribute("totalReplyCount", boardService.selectMyRepliesCount(totalParam));

        // 5. 화면(JSP)에서 탭과 필터 파란불(active)을 켜주기 위한 상태 유지 변수
        model.addAttribute("currentType", type);
        model.addAttribute("currentGame", game.toLowerCase());
        
        return "member/user_activity"; 
    }
	
 // =================================================================
    // [마이페이지] 댓글 수정 및 삭제 관리 (조회 및 일괄 삭제)
    // =================================================================

	// 1. 댓글 관리 페이지 조회 (목록 + 페이징)
	@GetMapping("/comment")
	public String MemberComment(
	        @RequestParam(value="cp", defaultValue="1") int cp, 
	        Authentication auth, 
	        Model model) {
	    
	    if (auth == null) return "redirect:/member/login";
	    int userNo = ((MemberExt) auth.getPrincipal()).getUserNo();

	    // 전체 조회를 위한 파라미터 (게임 구분 없이 내 모든 댓글)
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("userNo", userNo);

	    // 전체 댓글 개수 조회
	    int listCount = boardService.selectMyRepliesCount(paramMap);
	    
	    // 페이징 및 목록 조회 (한 페이지에 10개씩)
	    PageInfo pi = Pagination.getPageInfo(listCount, cp, 10, 10);
        
        // ✨ DAO에서 offset/limit 계산 처리를 해두었으므로 그대로 호출
	    List<Map<String, Object>> list = boardService.selectMyReplies(pi, paramMap);

	    model.addAttribute("list", list);
	    model.addAttribute("pi", pi);
	    model.addAttribute("totalReplyCount", listCount);

	    return "member/comment_edit";
	}
	
	// 2. 선택 댓글 일괄 삭제 (AJAX 전용)
	@PostMapping("/deleteReplies")
	@ResponseBody 
	public String deleteReplies(
	        @RequestParam(value="replyNos") List<Integer> replyNos, 
	        Authentication auth) {
	    
		if (replyNos == null || replyNos.isEmpty()) {
	        return "fail";
	    }
		
	    if (auth == null) return "error";
	    int userNo = ((MemberExt) auth.getPrincipal()).getUserNo();
	    
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("userNo", userNo);
	    paramMap.put("replyNos", replyNos); // 체크된 번호 리스트 전달
	    
	    int result = boardService.deleteMyReplies(paramMap);
	    
	    return (result > 0) ? "success" : "fail";
	}
    
   
	
	// 회원탈퇴 창
	@GetMapping("/delete_p")
	public String MemberDeletep() {
		return "member/user_delete_pop";
	}
	
	// 회원탈퇴
	@GetMapping("/delete")
	public String MemberDelete(Model model) {
		model.addAttribute("member", new Member());
		return "member/user_delete";
	}
	
	@PostMapping("/delete")
	public String MemberDeletePost(Model model, RedirectAttributes ra) {
		
		return "redirect:/";
	}
	
	// 회원가입
	@GetMapping("/join")
	public String MemberJoin(Model model) {
		model.addAttribute("member", new Member());
		return "member/user_join";
	}
	
	@PostMapping("/join")
	public String MemberJoinPost(Member m , Model model, RedirectAttributes ra) {
		int result = memberService.insertMember(m);
		
		if(result > 0) {
			ra.addFlashAttribute("alertMsg","회원가입 성공");
			return "redirect:/member/join";
		}else{
			model.addAttribute("errorMsg","회원가입에 실패했습니다.");
			return "common/errorPage";
		}
	}

	// 아이디비밀번호 찾기
	@GetMapping("/idpw")
	public String memberIdPw(Model model) {
		model.addAttribute("member", new Member());
		return "member/user_idpw";
	}
	
	@PostMapping("/idpw_id")
	@ResponseBody
	public String memberIdPost(@ModelAttribute Member member,
			ModelAndView mv,
			Model model,
			HttpSession session,
			RedirectAttributes ra) {
		
		Member FindId = memberService.findId(member);
		
		return (FindId != null) ? FindId.getUserId() : "";
	}
	
	@PostMapping("/idpw_pw")
	@ResponseBody
	public String memberPwPost(@ModelAttribute Member member,
			ModelAndView mv,
			Model model,
			HttpSession session,
			RedirectAttributes ra) {
		
		Member findMember = memberService.findPw(member);
		findMember.setUserId(member.getUserId());
		findMember.setUserName(member.getUserName());
		findMember.setEmail(member.getEmail());
		
	    if(findMember != null) {
	        // 1. 임시 비밀번호 생성 (8자리 랜덤 + "!")
	        String tempPw = "a" + UUID.randomUUID().toString().substring(0, 8) +"!";
	        // 2. 임시 비밀번호 암호화 후 DB 업데이트
	        // (BCryptPasswordEncoder 등을 사용하여 findMember의 비번을 tempPw로 변경하는 서비스 호출)
	        int result = memberService.updateTempPw(findMember.getUserId(),tempPw);
	        
	        // 3. 사용자에게는 암호화 안 된 "임시 번호"를 리턴
	        if (result == 1) {
	            return tempPw; // 성공 시 임시 비번 리턴
	        } else {
	            return "FAIL"; // 실패 시 처리
	        }
	    }
	    return "";
	}
	
	// 로그인
	@GetMapping("/login")
	public String loginMember() {
		return "member/login";
	}
	
	@PostMapping("/login")
	public ModelAndView login(
			@ModelAttribute Member member,
			ModelAndView mv,
			Model model,
			HttpSession session,
			RedirectAttributes ra
			) {
	
		// 로그인 요청 처리
		Member loginUser = memberService.loginMember(member);

		// 로그인 성공
		if(loginUser != null) {
			// 인증된 사용자 정보를 session에 보관
			model.addAttribute("loginUser",loginUser);
		}else{
			ra.addFlashAttribute("alertMsg","로그인 실패");
		}
		mv.setViewName("redirect:/"); // 메인페이지로 리다이렉트
		
		return mv;
	}
	
	@PostMapping("/logout")
	public String logout(HttpSession session, SessionStatus status) {
		status.setComplete(); 
		return "redirect:/";
	}
	
	// 회원가입 아이디 중복확인
	@ResponseBody // 반환값을 jsp가 아닌, 반환해야할 값으로 처리하게하는 주석
	@GetMapping("/idCheck")
	public int idCheck(String userId) {
		int result = memberService.idCheck(userId);
		
		return result;
	}
	
	@GetMapping("/pwCheck")
	@ResponseBody
	public int pwCheck(@RequestParam String userPw, Authentication auth) {

	    MemberExt loginUser = (MemberExt) auth.getPrincipal();

	    if(passwordEncoder.matches(userPw, loginUser.getUserPw())) {
	        return 1;
	    } else {
	        return 0;
	    }
	}
	
	@PostMapping("/pwCheck")
	@ResponseBody
	public int pwCheckPost(@RequestParam String userPw, Authentication auth) {

	    MemberExt loginUser = (MemberExt) auth.getPrincipal();

	    if(passwordEncoder.matches(userPw, loginUser.getUserPw())) {
	        return 1; // 일치
	    } else {
	        return 0; // 불일치
	    }
	}
	
	//회원가입 닉네임 중복확인
	@ResponseBody // 반환값을 jsp가 아닌, 반환해야할 값으로 처리하게하는 주석
	@GetMapping("/nameCheck")
	public int nameCheck(String userName) {
		int result = memberService.nameCheck(userName);
		
		return result;
	}
	
	@GetMapping("/insert") 
	public String enrollForm() {
		return "member/memberEnrollForm";
	}
	
	@PostMapping("/insert")
	public String insertMember(Member m , Model model, RedirectAttributes ra) {
		int result = memberService.insertMember(m);
		
		if(result > 0) {
			ra.addFlashAttribute("alertMsg","회원가입 완료!");
			return "redirect:/member/login";
		}else{
			model.addAttribute("errorMsg","회원가입에 실패했습니다.");
			return "common/errorPage";
		}
	}
	
	@GetMapping("/selectOne")
	public ResponseEntity<Member> selectOne(String userId){	
		Member searchMember = memberService.selectOne(userId);

		ResponseEntity<Member> res = null;
		if(searchMember != null) {
			// ok() : 응답상태 200
			res = ResponseEntity.ok(searchMember);
		}else{
			// 응답상태 404
			res = ResponseEntity.notFound().build();
		}
		return res;
	}
}