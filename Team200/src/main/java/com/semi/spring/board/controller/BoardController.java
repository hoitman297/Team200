package com.semi.spring.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

import org.springframework.core.io.ResourceLoader;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.semi.spring.board.model.service.BoardService;
import com.semi.spring.board.model.vo.Board;
import com.semi.spring.board.model.vo.BoardExt;
import com.semi.spring.board.model.vo.BoardType;
import com.semi.spring.board.model.vo.Reply;
import com.semi.spring.common.model.vo.PageInfo;
import com.semi.spring.common.template.Pagination;
import com.semi.spring.security.model.vo.MemberExt;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/board")
public class BoardController {
    
    private final BoardService boardService;
    private final ResourceLoader resourceLoader;
    private final ServletContext application;

    // 문의 메인
    @GetMapping("/inquiry")
    public String board_inquiry() {
        return "board/user_inquiry";
    }
    
    
    // 문의 상세 보기
    @GetMapping("/inquiryView")
    public String board_inquiryView() {
        return "board/user_inquiry_view";
    }
    
    // 문의 작성
    @GetMapping("/inquiryWrite")
    public String board_inquiryWrite() {
        return "board/user_inquiry_write";
    }
    
    // 게시글 상세 보기
    @GetMapping("/view")
    public String board_view(@RequestParam("boardNo") int boardNo, Model model) {
        boardService.increaseCount(boardNo);
        BoardExt board = boardService.selectBoard(boardNo);
        if (board == null) return "redirect:/";
        model.addAttribute("board", board);
        return "board/board_view";
    }
        
    // 공통 목록 조회 로직
    private void addBoardListToModel(Map<String, Object> paramMap, int cp, Model model) {
        int listCount = boardService.selectListCount(paramMap);
        PageInfo pi = Pagination.getPageInfo(listCount, cp, 10, 10);
        paramMap.put("pi", pi);
        List<Board> list = boardService.selectList(paramMap);
        model.addAttribute("boardList", list);
        model.addAttribute("pi", pi);
    }

    // 자유게시판 목록
    @GetMapping("/free_{gameCode}")
    public String freeGame(@PathVariable("gameCode") String gameCode,
                           @RequestParam(value="cp", defaultValue="1") int cp,
                           @RequestParam Map<String, Object> paramMap, Model model) {
        String dbGameCode = getDbGameCode(gameCode);
        BoardType gameConfig = boardService.getBoardTypeMap(dbGameCode , "자유");
        if (gameConfig == null) return "common/error";
        
        paramMap.put("gameCode", dbGameCode);
        paramMap.put("categoryNo", gameConfig.getCategoryNo());
        model.addAttribute("gameId", gameCode.toLowerCase());
        model.addAttribute("gameName", gameConfig.getCategoryName());
        addBoardListToModel(paramMap, cp, model);
        return "board/free_main_" + gameCode;
    }

    // 자유게시판 작성 폼
    @GetMapping("/free_write_{gameCode}")
    public String freeWriteGame(@PathVariable("gameCode") String gameCode, HttpSession session, Model model) {
        String dbGameCode = getDbGameCode(gameCode);
        BoardType gameConfig = boardService.getBoardTypeMap(dbGameCode, "자유");
        if (gameConfig == null) return "common/error";
        
        session.setAttribute("tempGameCode", dbGameCode);
        session.setAttribute("tempCategoryNo", gameConfig.getCategoryNo());
        session.setAttribute("tempBoardType", "free");
        model.addAttribute("gameId", gameCode.toLowerCase());
        model.addAttribute("gameName", gameConfig.getCategoryName());
        return "board/free_write_" + gameCode;
    }

    // 공략 게시판 목록
    @GetMapping("/strategy_{gameCode}")
    public String strategyGame(@PathVariable("gameCode") String gameCode,
                               @RequestParam(value="cp", defaultValue="1") int cp,
                               @RequestParam Map<String, Object> paramMap, Model model) {
        String dbGameCode = getDbGameCode(gameCode);
        BoardType gameConfig = boardService.getBoardTypeMap(dbGameCode , "공략");
        if (gameConfig == null) return "common/error";
        
        paramMap.put("gameCode", dbGameCode);
        paramMap.put("categoryNo", gameConfig.getCategoryNo());
        model.addAttribute("gameId", gameCode.toLowerCase());
        model.addAttribute("gameName", gameConfig.getCategoryName());
        addBoardListToModel(paramMap, cp, model);
        return "board/strategy_main_" + gameCode;
    }

    // 공략게시판 작성 폼
    @GetMapping("/strategy_write_{gameCode}")
    public String strategyWriteGame(@PathVariable("gameCode") String gameCode, HttpSession session, Model model) {
        String dbGameCode = getDbGameCode(gameCode);
        BoardType gameConfig = boardService.getBoardTypeMap(dbGameCode, "공략");
        if (gameConfig == null) return "common/error";
        
        session.setAttribute("tempGameCode", dbGameCode);
        session.setAttribute("tempCategoryNo", gameConfig.getCategoryNo());
        session.setAttribute("tempBoardType", "strategy");
        model.addAttribute("gameId", gameCode.toLowerCase());
        model.addAttribute("gameName", gameConfig.getCategoryName());
        return "board/strategy_write_" + gameCode;
    }

    // 통합 글 작성 처리
    @PostMapping("/{boardType}_write_{gameCode}")
    public String insertBoard(@PathVariable("boardType") String boardType,
                             @PathVariable("gameCode") String gameCode, 
                             Board board,
                             @RequestParam(value="upFile", required=false) List<MultipartFile> upFiles,
                             Authentication auth, HttpSession session, RedirectAttributes ra) {
        if (auth == null) {
            ra.addFlashAttribute("message", "로그인 후 이용 가능합니다.");
            return "redirect:/member/login";
        }
        String tempGameCode = (String) session.getAttribute("tempGameCode");
        Integer tempCategoryNo = (Integer) session.getAttribute("tempCategoryNo");
        if (tempGameCode == null) return "redirect:/";

        MemberExt loginUser = (MemberExt)auth.getPrincipal();
        board.setUserNo(loginUser.getUserNo());
        board.setGameCode(tempGameCode);
        board.setCategoryNo(tempCategoryNo);
        
        String savePath = session.getServletContext().getRealPath("/resources/upload/board/");
        int result = boardService.insertBoard(board, upFiles, savePath);
        
        session.removeAttribute("tempGameCode");
        session.removeAttribute("tempCategoryNo");

        if(result > 0) {
            ra.addFlashAttribute("message", "게시글이 등록되었습니다.");
            return "redirect:/board/" + boardType + "_" + gameCode;
        }
        return "redirect:/";
    }

    // 게시글 수정 폼
    @GetMapping("/edit")
    public String editBoardForm(@RequestParam("boardNo") int boardNo, Authentication auth, RedirectAttributes ra, Model model) {
        BoardExt board = boardService.selectBoard(boardNo);
        MemberExt loginUser = (MemberExt)auth.getPrincipal();
        if (board == null || board.getUserNo() != loginUser.getUserNo()) {
            ra.addFlashAttribute("message", "수정 권한이 없습니다.");
            return "redirect:/board/view?boardNo=" + boardNo;
        }
        model.addAttribute("board", board);
        return "board/board_edit";
    }

    // 게시글 수정 처리
    @PostMapping("/edit")
    public String updateBoard(Board board, @RequestParam(value="upFile", required=false) List<MultipartFile> upFiles,
                             Authentication auth, HttpSession session, RedirectAttributes ra) {
        String savePath = session.getServletContext().getRealPath("/resources/upload/board/");
        // int result = boardService.updateBoard(board, upFiles, savePath); // 서비스 구현 후 주석 해제
        int result = 1; 
        ra.addFlashAttribute("message", result > 0 ? "수정되었습니다." : "수정 실패");
        return "redirect:/board/view?boardNo=" + board.getBoardNo();
    }

    // 게시글 삭제 처리
    @GetMapping("/delete")
    public String deleteBoard(@RequestParam("boardNo") int boardNo, Authentication auth, RedirectAttributes ra) {
        BoardExt board = boardService.selectBoard(boardNo);
        MemberExt loginUser = (MemberExt)auth.getPrincipal();
        if (board == null || board.getUserNo() != loginUser.getUserNo()) return "redirect:/";
        
        // int result = boardService.deleteBoard(boardNo); // 서비스 구현 후 주석 해제
        int result = 1;
        if(result > 0) {
            String type = "자유".equals(board.getBoardType()) ? "free" : "strategy";
            return "redirect:/board/" + type + "_" + board.getGameCode().toLowerCase();
        }
        return "redirect:/board/view?boardNo=" + boardNo;
    }

    // 공감(좋아요) 처리
    @PostMapping("/addLike")
    @ResponseBody
    public Map<String, Object> addLike(@RequestParam("boardNo") int boardNo, Authentication auth) {
        Map<String, Object> response = new HashMap<>();
        if (auth == null) {
            response.put("status", "error");
            return response;
        }
        int result = boardService.insertBoardLike(boardNo, ((MemberExt)auth.getPrincipal()).getUserNo());
        if (result == -1) response.put("status", "already");
        else {
            response.put("status", "success");
            response.put("newLikeCount", result);
        }
        return response;
    }

    // 댓글 목록 (AJAX)
    @ResponseBody
    @GetMapping(value = "/reply/list", produces = "application/json; charset=UTF-8")
    public List<Reply> selectReplyList(int boardNo) {
        return boardService.selectReplyList(boardNo);
    }

    // 댓글 작성 (AJAX)
    @ResponseBody
    @PostMapping("/reply/insert")
    public String insertReply(Reply reply, Authentication auth) {
        if (auth == null) return "login";
        reply.setUserNo(((MemberExt)auth.getPrincipal()).getUserNo());
        return boardService.insertReply(reply) > 0 ? "success" : "fail";
    }

    // 게임코드 변환 헬퍼 메서드
    private String getDbGameCode(String gameCode) {
        switch(gameCode.toLowerCase()) {
            case "battleground": return "BG";
            case "overwatch": return "OW";
            case "lol": return "LOL";
            default: return gameCode.toUpperCase();
        }
    }
}