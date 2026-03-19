package com.semi.spring.member.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
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
}

