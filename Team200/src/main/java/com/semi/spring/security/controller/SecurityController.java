package com.semi.spring.security.controller;

import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.beans.propertyeditors.CustomDateEditor;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.semi.spring.member.model.validator.MemberValidator;
import com.semi.spring.member.model.vo.Member;
import com.semi.spring.security.model.vo.MemberExt;
import com.semi.spring.member.service.MemberService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/security")
@Controller
public class SecurityController {

	// 필드방식 의존성 주입
	//@Autowired
	private MemberService mService;
	
	//@Autowired
	private BCryptPasswordEncoder passwordEncoder;
		
	// 생성자에 의해 자동 의존성 주입 방식
	// 단, 생성자가 여러개면 @Autowired어노테이션 필요
	public SecurityController(MemberService mService , BCryptPasswordEncoder passwordEncoder) {
		this.mService = mService;
		this.passwordEncoder = passwordEncoder;
	}
	
	@RequestMapping("/accessDenied")
	public String accessDenied(Model m) {
		m.addAttribute("errorMsg","접근 불가능한 페이지입니다.");
		return "common/errorPage";
	}
	
	@GetMapping("/insert")
	public String enroll(@ModelAttribute Member member) { // model영역에 커맨드객체 바인딩
		return "member/memberEnrollForm";
	}

	@PostMapping("/insert")
	public String register(
		@Validated @ModelAttribute Member member,
		BindingResult bindingResult, // 유효성검사결과.
		RedirectAttributes ra
	) {
		// 유효성 검사 실패
		if(bindingResult.hasErrors()) {
			return "member/memberEnrollForm";
		}
		
		// 유효성 검사 성공시 비밀번호 암호화하여 회원가입 진행
		String encryptedPassword
			= passwordEncoder.encode(member.getUserPwd());
		member.setUserPwd(encryptedPassword); // 원래는 Filter에서 처리
		
		mService.insertMember(member);
		return "redirect:/member/login";
	}
	/*
	 * Authentication
	 *  - Principal : 인증에 사용된 사용자 객체
	 *  - Credentials : 인증에 필요한 비밀번호에 대한 정보를 가진 객체
	 *  - Authorities : 사용자가 가진 권한을 저장하는 객체
	 */
	@GetMapping("/mypage")
	public String myPage(
			Authentication auth ,
			Principal principal ,
			Model model
			) {
		log.debug("auth = {}",auth);
		log.debug("principal = {}",principal);
		
		// SecurityContextHolder를 이용해서 사용자 정보 바인딩
		Authentication auth2 = SecurityContextHolder.getContext().getAuthentication();
		
		MemberExt loginUser = (MemberExt)auth2.getPrincipal();
		
		model.addAttribute("loginUser", loginUser);
		return "member/mypage";
	}
	
	@PostMapping("/update")
	public String update(
			@Validated @ModelAttribute MemberExt loginUser,
			BindingResult bindResult,
			Authentication auth , // 로그인한 사용자 인증정보
			RedirectAttributes ra
			) {
		if(bindResult.hasErrors()) {
			return "redirect:/security/myPage";
		}
		
		// 비지니스 로직
		// 1. 전달받은 member데이터를 바탕으로 DB수정요청
		int result = mService.updateMember(loginUser);
		
		// 2. 내 정보 수정이 성공했다면, 변경된 회원 정보를 DB에서 다시 조회한 후
	    // 	  새로운 인증정보를 생성하여 SecurityContext에 저장
		if(result > 0) {  // (principal, credentails, authorities)
			Authentication newAuth = 
				new UsernamePasswordAuthenticationToken(
						loginUser , auth.getCredentials() ,
						auth.getAuthorities());
			SecurityContextHolder
				.getContext()
				.setAuthentication(newAuth);
			ra.addFlashAttribute("alertMsg","회원정보 수정 완료");
			
			return "redirect:/security/myPage";
		}else{
			throw new RuntimeException("회원정보 수정 오류.");
		}
		
	}
}

