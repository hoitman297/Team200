package com.semi.spring.member.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.semi.spring.member.model.vo.Member;
import com.semi.spring.member.service.MemberService;

@Controller
@RequestMapping("/member")
@SessionAttributes({"loginUser"})
public class MemberController {
	
	// private MemberService memberService = new MemberService();
	@Autowired 
	private MemberService memberService;
	
	// 마이페이지
	@GetMapping("/mypage")
	public String MemberMypage() {
		return "member/user_mypage";
	}
	
	// 회원정보 수정
	@GetMapping("/update")
	public String MemberUpdate() {
		return "member/user_update";
	}
	
	// 게시글, 댓글 조회
	@GetMapping("/activity")
	public String MemberActivity() {
		return "member/user_activity";
	}
	
	// 삭제 및 수정
	@GetMapping("/comment")
	public String MemberComment() {
		return "member/comment_edit";
	}
	
	// 회원탈퇴 창
	@GetMapping("/delete_p")
	public String MemberDeletep() {
		return "member/user_delete_pop";
	}
	
	// 회원탈퇴
	@GetMapping("/delete")
	public String MemberDelete() {
		return "member/user_delete";
	}
	
	// 회원가입
	@GetMapping("/join")
	public String MemberJoin() {
		return "member/user_join";
	}
	
	// 아이디비밀번호 찾기
	@GetMapping("/idpw")
	public String memberIdpw() {
		return "member/user_idpw";
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
			// session.setAttribute("alertMsg", "로그인 실패");
			ra.addFlashAttribute("alertMsg","로그인 실패");
			/*
			 * RedirectAttributes의 flashAttribute는 데이터를 우선
			 * SessionScope에 담았다가, 리다이렉트가 완료되면 SessionScope의
			 * 데이터를 request Scope로 변경해준다.
			 */
		}
		mv.setViewName("redirect:/"); // 메인페이지로 리다이렉트
		
		return mv;
	}
	
	@GetMapping("/logout")
	public String logout(HttpSession session, SessionStatus status) {
		// 로그아웃으로 현재 세션의 인증정보를 만료
		
		// session.invalidate() : session내부의 모든 데이터를 삭제시키는 메서드
		
		status.setComplete(); // model로 sessionScope에 이관된 데이터를 삭제하는 메서드		
		return "redirect:/";
	}
	
	// 회원가입 아이디 중복확인
	@ResponseBody // 반환값을 jsp가 아닌, 반환해야할 값으로 처리하게하는 주석
	@GetMapping("/idcheck")
	public int idCheck(String userId) {
		int result = memberService.idCheck(userId);
		
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