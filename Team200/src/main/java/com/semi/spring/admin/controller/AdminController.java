package com.semi.spring.admin.controller;

import javax.servlet.ServletContext;

import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.semi.spring.admin.service.AdminService;
import com.semi.spring.board.model.service.BoardService;
import com.semi.spring.board.model.vo.Inquiry;
import com.semi.spring.board.model.vo.Notice;
import com.semi.spring.board.model.vo.Patchnote;
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
	public String adminMain() {
		return "admin/admin_main";
	}
	
	@GetMapping("/inquiry")
	public String adminInquiry(
			@ModelAttribute Inquiry inquiry,
			Model model) {
		
		model.addAttribute(inquiry);
		
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
	
	@GetMapping("/notice")
	public String adminNotice(@ModelAttribute("notice") Notice notice) {
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
	public String adminPatchnote(@ModelAttribute("patchnote") Patchnote patchnote){
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
	
	@GetMapping("/user_content_management")
	public String userContentManagerMent() {
		return "admin/user_content_management";
	}
	
	@GetMapping("/user_management")
	public String userManagement() {
		return "admin/user_management";
	}
	
}
