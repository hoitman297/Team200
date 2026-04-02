package com.semi.spring.gallery.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.semi.spring.board.model.service.BoardService;
import com.semi.spring.board.model.vo.Board;
import com.semi.spring.board.model.vo.BoardExt;
import com.semi.spring.common.model.vo.PageInfo;
import com.semi.spring.common.template.Pagination;
import com.semi.spring.security.model.vo.MemberExt;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/gallery")
public class GalleryController {

    private final BoardService boardService;

    // ── 1. 갤러리 목록 ──────────────────────────────────────────
    @GetMapping("/list")
    public String galleryList(
            @RequestParam(value = "gameCode", defaultValue = "all") String gameCode,
            @RequestParam(value = "cp", defaultValue = "1") int cp,
            Model model) {

        Map<String, Object> paramMap = new HashMap<>();
        // "all"이면 조건 없이 전체 조회 (매퍼 <if> 로 처리됨)
        paramMap.put("gameCode", gameCode.equals("all") ? null : gameCode.toUpperCase());

        // 전체 건수
        int listCount = boardService.selectGalleryCount(paramMap);

        // 페이징 정보 (한 페이지 12개, 페이지 블록 5개)
        PageInfo pi = Pagination.getPageInfo(listCount, cp, 12, 5);

        // startRow / endRow 계산 (매퍼 SQL 이 BETWEEN #{startRow} AND #{endRow} 사용)
        int startRow = (pi.getCurrentPage() - 1) * pi.getBoardLimit() + 1;
        int endRow   = startRow + pi.getBoardLimit() - 1;
        paramMap.put("startRow", startRow);
        paramMap.put("endRow",   endRow);

        List<BoardExt> list = boardService.selectGalleryList(paramMap);

        model.addAttribute("list", list);
        model.addAttribute("pi", pi);
        model.addAttribute("gameCode", gameCode); // JSP currentGame 용

        return "gallery/gallery_list";
    }

    // ── 2. 갤러리 글쓰기 폼 ──────────────────────────────────────
    @GetMapping("/write")
    public String galleryWrite(Authentication auth, RedirectAttributes ra) {
        if (auth == null) {
            ra.addFlashAttribute("message", "로그인 후 이용 가능합니다.");
            return "redirect:/member/login";
        }
        return "gallery/gallery_write";
    }

    // ── 3. 갤러리 등록 처리 ──────────────────────────────────────
    @PostMapping("/insert")
    public String insertGallery(
            Board board,
            @RequestParam(value = "upFile", required = false) List<MultipartFile> upFiles,
            Authentication auth,
            HttpSession session,
            RedirectAttributes ra) {

        // 로그인 체크
        if (auth == null) {
            ra.addFlashAttribute("message", "로그인 후 이용 가능합니다.");
            return "redirect:/member/login";
        }

        MemberExt loginUser = (MemberExt) auth.getPrincipal();
        board.setUserNo(loginUser.getUserNo());

        // gameCode 정규화 (폼 hidden 값 → 대문자)
        String gameCode = board.getGameCode() != null
                ? board.getGameCode().toUpperCase() : "BG";
        board.setGameCode(gameCode);

        // 갤러리 카테고리 번호 조회
        Map<String, Object> catParam = new HashMap<>();
        catParam.put("gameCode",      gameCode);
        catParam.put("categoryName",  "갤러리");
        int categoryNo = boardService.selectCategoryNoByName(catParam);

        if (categoryNo == 0) {
            ra.addFlashAttribute("message", "갤러리 카테고리를 찾을 수 없습니다.");
            return "redirect:/gallery/write?gameCode=" + gameCode.toLowerCase();
        }
        board.setCategoryNo(categoryNo);

        // 파일 저장 경로
        String savePath = session.getServletContext()
                .getRealPath("/resources/upload/board/");

        int result = boardService.insertBoard(board, upFiles, savePath);

        if (result > 0) {
            ra.addFlashAttribute("message", "갤러리에 등록되었습니다.");
            return "redirect:/gallery/list?gameCode=" + gameCode;
        }
        ra.addFlashAttribute("message", "등록에 실패했습니다.");
        return "redirect:/gallery/write?gameCode=" + gameCode.toLowerCase();
    }
}