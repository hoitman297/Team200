package com.semi.spring.gallery.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.semi.spring.board.model.service.BoardService;
import com.semi.spring.board.model.vo.BoardExt;
import com.semi.spring.common.model.vo.PageInfo;
import com.semi.spring.common.template.Pagination;
import com.semi.spring.member.model.vo.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/gallery")
public class GalleryController {
	
	private final BoardService boardService;
	
	// 갤러리
	@RequestMapping("/list")
	public String galleryList(
	        @RequestParam(value="game", defaultValue="all") String game,
	        @RequestParam(value="cp", defaultValue="1") int cp,
	        Model model) {
	    
	    // 1. 전체 갤러리 개수 조회
	    int listCount = boardService.selectGalleryCount(game);
	    
	    // 2. 페이지네이션 (한 페이지에 12개씩 보여주는 게 갤러리 그리드에 예뻐요!)
	    PageInfo pi = Pagination.getPageInfo(cp, listCount, 10, 12);
	    
	    // 3. 목록 조회
	    List<BoardExt> list = boardService.selectGalleryList(pi, game);
	    
	    model.addAttribute("list", list);
	    model.addAttribute("pi", pi);
	    model.addAttribute("currentGame", game); // 현재 선택된 탭 활성화용
	    
	    return "gallery/gallery_list"; 
	}
	
	// 갤러리 등록
	@RequestMapping("/write")
	public String galleryWrite(@RequestParam(value="game", defaultValue="BG") String game, Model model) {
		model.addAttribute("game", game);
        return "gallery/gallery_write"; 
    }
	
	@PostMapping("/insert")
	public String insertGallery(
	        BoardExt board, // 제목, 내용, 게임코드(LOL, BG 등)가 담김
	        @RequestParam("fileInput") List<MultipartFile> upFiles,
	        HttpSession session,
	        RedirectAttributes ra) {
	    
	    // 1. 로그인 유저 정보 세팅
	    Member loginUser = (Member)session.getAttribute("loginUser");
	    if(loginUser != null) {
	        board.setUserNo(loginUser.getUserNo());
	    }

	    // 2. 저장 경로 설정
	    String savePath = session.getServletContext().getRealPath("/resources/upload/board/");
	    
	    // 3. 서비스 호출
	    int result = boardService.insertGallery(board, upFiles, savePath);
	    
	    if(result > 0) {
	        ra.addFlashAttribute("message", "갤러리에 등록되었습니다! 📸");
	        return "redirect:/gallery/list?game=" + board.getGameCode().toLowerCase();
	    } else {
	        ra.addFlashAttribute("message", "등록 실패 ㅠㅠ");
	        return "redirect:/gallery/write";
	    }
	}
}
