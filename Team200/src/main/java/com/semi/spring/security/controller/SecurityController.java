package com.semi.spring.security.controller;

import java.security.Principal;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.semi.spring.member.model.validator.MemberValidator;
import com.semi.spring.member.model.vo.Member;
import com.semi.spring.member.service.MemberService;
import com.semi.spring.security.model.vo.MemberExt;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/security")
@RequiredArgsConstructor
@Controller
public class SecurityController {

	private final MemberService memberService;
	private final BCryptPasswordEncoder passwordEncoder;
	
	@InitBinder
	public void initBinder(WebDataBinder binder) {
		binder.addValidators(new MemberValidator());
	}
		
	@RequestMapping("/accessDenied")
	public String accessDenied(Model m) {
		m.addAttribute("errorMsg","접근 불가능한 페이지입니다.");
		return "common/errorPage";
	}
	
	@GetMapping("/join")
	public String enroll(@ModelAttribute Member member) { // model영역에 커맨드객체 바인딩
		return "member/user_join";
	}

	@PostMapping("/join")
	public String register(
		@Validated @ModelAttribute Member member,
		BindingResult bindingResult, // 유효성검사결과.
		RedirectAttributes ra
	) {
		if(bindingResult.hasErrors()) {
			return "member/user_join";
		}
		
		String rawPwd = member.getUserPw();
		String encryptedPassword
			= passwordEncoder.encode(member.getUserPw());
		member.setUserPw(encryptedPassword); 
		
		memberService.insertMember(member);
		return "redirect:/member/login";
	}
	
	@GetMapping("/update")
	public String update() {
		return "member/update";
	}
	
	@PostMapping("/update")
	public String updatePost(
			@ModelAttribute MemberExt loginUser,
			Authentication auth ,
			RedirectAttributes ra
			) {
		
		MemberExt principal = (MemberExt)auth.getPrincipal();
		
	    if(loginUser.getUserPw() != null && !loginUser.getUserPw().isEmpty()) {
	        loginUser.setUserPw(passwordEncoder.encode(loginUser.getUserPw()));
	    }else {
	    	loginUser.setUserPw(null);
	    }
		
		// DB수정요청
		int result = memberService.updateMember(loginUser);
		
	    // 새로운 인증정보를 생성하여 SecurityContext에 저장
		if(result > 0) { 
			principal.setUserName(loginUser.getUserName());
	        principal.setEmail(loginUser.getEmail());
			
			Authentication newAuth = new UsernamePasswordAuthenticationToken(
					principal , 
					auth.getCredentials() ,
					auth.getAuthorities());
			
			SecurityContextHolder.getContext().setAuthentication(newAuth);
			
			ra.addFlashAttribute("alertMsg","회원정보 수정 완료");
			return "redirect:/";
		}else{
			throw new RuntimeException("회원정보 수정 오류.");
		}
	}

	@GetMapping("/delete")
	public String delete(@ModelAttribute Member member) {
		return "member/user_delete";
	}
	
	// WITHDRAW = 'Y' STATUS = 'Y'
	@PostMapping("/delete")
	public String deletePost(
			@ModelAttribute Member member,
			@RequestParam("userPw") String userPw,
			HttpServletRequest request,
	        Authentication auth,
	        RedirectAttributes ra,
	        Model model)
	{
		
		MemberExt loginUser = (MemberExt)auth.getPrincipal();
		
		if(!passwordEncoder.matches(userPw, loginUser.getUserPw())) {
	        model.addAttribute("errorMsg", "비밀번호가 일치하지 않습니다.");
	        return "common/errorPage";
	    }
		
		// 유효성 검사 성공시 탈퇴 진행
		int result = memberService.deleteMember(loginUser.getUserId());
		if(result > 0) {
			
			// 1. SecurityContext 제거
	        SecurityContextHolder.clearContext();

	        // 2. HttpSession 무효화 
	        HttpSession session = request.getSession(false);
	        if(session != null) {
	            session.invalidate();
	        }
		
			ra.addFlashAttribute("alertMsg","삭제 성공");
			return "redirect:/";
		}else {
			model.addAttribute("errorMsg","오류로 인해 삭제 실패");
			return "common/errorPage";
		}
	}
	/*
	 * Authentication
	 *  - Principal : 인증에 사용된 사용자 객체
	 *  - Credentials : 인증에 필요한 비밀번호에 대한 정보를 가진 객체
	 *  - Authorities : 사용자가 가진 권한을 저장하는 객체
	 */
//	@GetMapping("/idpw")
//	public String idpw(@ModelAttribute Member member) {
//	
//		return "member/user_join";
//	}
	
//	@PostMapping("/idpw")
//	public String idpwPost() {
//		
//		return null;
//	}
	
	@GetMapping("/mypage")
	public String myPage(
			@ModelAttribute Member member,
			Authentication auth ,
			Principal principal ,
			Model model
			) {
		log.debug("auth = {}",auth);
		log.debug("principal = {}",principal);
		
		// SecurityContextHolder를 이용해서 사용자 정보 바인딩
		Authentication userAuth = SecurityContextHolder.getContext().getAuthentication();
		
		MemberExt loginUser = (MemberExt)userAuth.getPrincipal();
		
		model.addAttribute("loginUser", loginUser);
		return "member/mypage";
	}
}

