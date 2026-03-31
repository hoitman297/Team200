package com.semi.spring.member.controller;

import java.util.HashMap;
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

import com.semi.spring.member.model.vo.Member;
import com.semi.spring.member.service.MemberService;
import com.semi.spring.security.model.vo.MemberExt;

@Controller
@RequestMapping("/member")
@SessionAttributes({"loginUser"})
public class MemberController {
	
	@Autowired
	private BCryptPasswordEncoder passwordEncoder;
	
	@Autowired 
	private MemberService memberService;
	
	// 마이페이지
	@GetMapping("/mypage")
	public String MemberMypage(@ModelAttribute Member member) {
		return "member/user_mypage";
	}
	
	// 회원정보 수정
	@GetMapping("/update")
	public String MemberUpdate(Model model) {
		model.addAttribute("member", new Member());
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