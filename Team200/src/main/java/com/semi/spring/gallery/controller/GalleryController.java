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

    @GetMapping("/list")
    public String galleryList(
            @RequestParam(value = "gameCode", defaultValue = "all") String gameCode,
            @RequestParam(value = "cp", defaultValue = "1") int cp,
            Model model) {

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("gameCode", gameCode.equals("all") ? null : gameCode.toUpperCase());

        int listCount = boardService.selectGalleryCount(paramMap);
        PageInfo pi = Pagination.getPageInfo(listCount, cp, 12, 5);

        int startRow = (pi.getCurrentPage() - 1) * pi.getBoardLimit() + 1;
        int endRow   = startRow + pi.getBoardLimit() - 1;
        paramMap.put("startRow", startRow);
        paramMap.put("endRow",   endRow);

        List<BoardExt> list = boardService.selectGalleryList(paramMap);

        model.addAttribute("list", list);
        model.addAttribute("pi", pi);
        model.addAttribute("gameCode", gameCode);

        return "gallery/gallery_list";
    }

    @GetMapping("/write")
    public String galleryWrite(@RequestParam(value="gameCode", required=false) String gameCode, 
                               @RequestParam(value="game", required=false) String game,
                               Authentication auth, RedirectAttributes ra, Model model) {
        if (auth == null) {
            ra.addFlashAttribute("message", "로그인 후 이용 가능합니다.");
            return "redirect:/member/login";
        }

        // 🌟 gameCode가 없으면 game 파라미터라도 확인, 둘 다 없으면 BG
        String target = (gameCode != null) ? gameCode : (game != null ? game : "BG");
        target = target.toUpperCase();

        // 404 방지용 풀네임 변환
        String pathId = "battleground";
        String displayCode = "BG";
        
        if(target.contains("LOL")) { pathId = "lol"; displayCode = "LOL"; }
        else if(target.contains("OW") || target.contains("OVERWATCH")) { pathId = "overwatch"; displayCode = "OW"; }
        
        model.addAttribute("gameId", pathId); 
        model.addAttribute("gameCode", displayCode); // JSP 드롭다운 선택용
        return "gallery/gallery_write";
    }

    @PostMapping("/insert")
    public String insertGallery(
            Board board,
            @RequestParam(value = "upFile", required = false) List<MultipartFile> upFiles,
            Authentication auth,
            HttpSession session,
            RedirectAttributes ra) {

        if (auth == null) {
            ra.addFlashAttribute("message", "로그인 후 이용 가능합니다.");
            return "redirect:/member/login";
        }

        MemberExt loginUser = (MemberExt) auth.getPrincipal();
        board.setUserNo(loginUser.getUserNo());

        String gameCode = (board.getGameCode() != null && !board.getGameCode().isEmpty())
                ? board.getGameCode().toUpperCase() : "BG";
        board.setGameCode(gameCode);

        Map<String, Object> catParam = new HashMap<>();
        catParam.put("gameCode", gameCode);
        catParam.put("categoryName", "갤러리");
        
        int categoryNo = boardService.selectCategoryNoByName(catParam);
        
        if (categoryNo <= 0) {
            ra.addFlashAttribute("message", "시스템 오류: 카테고리 누락");
            return "redirect:/gallery/list?gameCode=" + gameCode.toLowerCase();
        }
        board.setCategoryNo(categoryNo);

        String savePath = session.getServletContext().getRealPath("/resources/upload/board/");

        try {
            int result = boardService.insertBoard(board, upFiles, savePath);
            if (result > 0) {
                ra.addFlashAttribute("message", "갤러리에 등록되었습니다.");
                return "redirect:/gallery/list?gameCode=" + gameCode;
            }
        } catch (Exception e) {
            log.error("❌ 등록 중 예외 발생: " + e.getMessage());
        }

        return "redirect:/gallery/write?gameCode=" + gameCode.toLowerCase();
    }
}