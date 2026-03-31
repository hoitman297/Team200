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
    private final ServletContext application; // application scope

    // 문의 메인
    @GetMapping("/inquiry")
    public String board_inquiry() {
        return "board/user_inquiry";
    }
    
    // 문의 작성
    @GetMapping("/inquiryWrite")
    public String board_inquiryWrite() {
        return "board/user_inquiry_write";
    }
    
    // 게시글 상세 보기
    @GetMapping("/view")
    public String board_view(
            @RequestParam("boardNo") int boardNo,
            Model model) {
        
        boardService.increaseCount(boardNo);
        BoardExt board = boardService.selectBoard(boardNo);
        
        if (board == null) {
            return "redirect:/";
        }
        
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

    // 글 타입별 게임별 자유게시판
    @GetMapping("/free_{gameCode}")
    public String freeGame(
            @PathVariable("gameCode") String gameCode,
            @RequestParam(value="cp", defaultValue="1") int cp,
            @RequestParam Map<String, Object> paramMap,
            Model model) {

        String dbGameCode = "";
        
        switch(gameCode.toLowerCase()) {
            case "battleground": dbGameCode = "BG"; break;
            case "overwatch":    dbGameCode = "OW"; break;
            case "lol":          dbGameCode = "LOL"; break;
            default:             dbGameCode = gameCode.toUpperCase();
        }
        
        BoardType gameConfig = boardService.getBoardTypeMap(dbGameCode , "자유");
        
        if (gameConfig == null) {
            return "common/error";
        }
        
        paramMap.put("gameCode", dbGameCode);
        paramMap.put("categoryNo", gameConfig.getCategoryNo());

        String safeGameId = gameCode.toLowerCase().equals("battleground") ? "bg" : 
                            gameCode.toLowerCase().equals("overwatch") ? "ow" : "lol";
        
        model.addAttribute("gameId", safeGameId);
        model.addAttribute("gameName", gameConfig.getCategoryName());
        
        addBoardListToModel(paramMap, cp, model);
        
        return "board/free_main_" + gameCode;
    }
        
    // 게임별 자유게시판 작성 페이지
    @GetMapping("/free_write_{gameCode}")
    public String freeWriteGame(
            @PathVariable("gameCode") String gameCode,
            HttpSession session, 
            Model model) {
        
        String dbGameCode = "";
        switch(gameCode.toLowerCase()) {
            case "battleground": dbGameCode = "BG"; break;
            case "overwatch":    dbGameCode = "OW"; break;
            case "lol":          dbGameCode = "LOL"; break;
            default:             dbGameCode = gameCode.toUpperCase();
        }
        
        BoardType gameConfig = boardService.getBoardTypeMap(dbGameCode, "자유");
        
        if (gameConfig == null) {
            return "common/error";
        }
        
        session.setAttribute("tempGameCode", dbGameCode);
        session.setAttribute("tempCategoryNo", gameConfig.getCategoryNo());
        session.setAttribute("tempBoardType", "free");

        String safeGameId = gameCode.toLowerCase().equals("battleground") ? "bg" : 
                            gameCode.toLowerCase().equals("overwatch") ? "ow" : "lol";
        model.addAttribute("gameId", safeGameId);
        model.addAttribute("gameName", gameConfig.getCategoryName());

        return "board/free_write_" + gameCode;
    }
    
    // 게임별 공략 게시판
    @GetMapping("/strategy_{gameCode}")
    public String strategyGame(
            @PathVariable("gameCode") String gameCode,
            @RequestParam(value="cp", defaultValue="1") int cp,
            @RequestParam Map<String, Object> paramMap,
            Model model) {

        String dbGameCode = "";
        
        switch(gameCode.toLowerCase()) {
            case "battleground": dbGameCode = "BG"; break;
            case "overwatch":    dbGameCode = "OW"; break;
            case "lol":          dbGameCode = "LOL"; break;
            default:             dbGameCode = gameCode.toUpperCase();
        }
        
        BoardType gameConfig = boardService.getBoardTypeMap(dbGameCode , "공략");
        
        if (gameConfig == null) {
            return "common/error";
        }
        
        paramMap.put("gameCode", dbGameCode);
        paramMap.put("categoryNo", gameConfig.getCategoryNo());

        String safeGameId = gameCode.toLowerCase().equals("battleground") ? "bg" : 
                            gameCode.toLowerCase().equals("overwatch") ? "ow" : "lol";
        
        model.addAttribute("gameId", safeGameId);
        model.addAttribute("gameName", gameConfig.getCategoryName());
        
        addBoardListToModel(paramMap, cp, model);
        
        return "board/strategy_main_" + gameCode;
    }

    // 게임별 공략게시판 작성 페이지
    @GetMapping("/strategy_write_{gameCode}")
    public String strategyWriteGame(
            @PathVariable("gameCode") String gameCode,
            HttpSession session, 
            Model model) {
        
        String dbGameCode = "";
        switch(gameCode.toLowerCase()) {
            case "battleground": dbGameCode = "BG"; break;
            case "overwatch":    dbGameCode = "OW"; break;
            case "lol":          dbGameCode = "LOL"; break;
            default:             dbGameCode = gameCode.toUpperCase();
        }
        
        BoardType gameConfig = boardService.getBoardTypeMap(dbGameCode, "공략");
        
        if (gameConfig == null) {
            return "common/error";
        }
        
        session.setAttribute("tempGameCode", dbGameCode);
        session.setAttribute("tempCategoryNo", gameConfig.getCategoryNo());
        session.setAttribute("tempBoardType", "strategy");

        String safeGameId = gameCode.toLowerCase().equals("battleground") ? "bg" : 
                            gameCode.toLowerCase().equals("overwatch") ? "ow" : "lol";
        model.addAttribute("gameId", safeGameId);
        model.addAttribute("gameName", gameConfig.getCategoryName());

        return "board/strategy_write_" + gameCode;
    }    
    
    // 통합 글 작성
    @PostMapping("/{boardType}_write_{gameCode}")
    public String insertBoard(
            @PathVariable("boardType") String boardType,
            @PathVariable("gameCode") String gameCode, 
            Board board,
            @RequestParam("title") String title,     
            @RequestParam("content") String content, 
            @RequestParam(value="upFile", required=false) List<MultipartFile> upFiles,
            Authentication auth,
            HttpSession session, 
            RedirectAttributes ra) {
        
        if (auth == null || !auth.isAuthenticated()) {
            ra.addFlashAttribute("message", "로그인 후 이용 가능합니다.");
            return "redirect:/member/login";
        }

        String tempGameCode = (String) session.getAttribute("tempGameCode");
        Integer tempCategoryNo = (Integer) session.getAttribute("tempCategoryNo");
        
        if (tempGameCode == null || tempCategoryNo == null) {
            ra.addFlashAttribute("message", "작성 시간이 만료되었거나 잘못된 접근입니다.");
            return "redirect:/";
        }
        
        MemberExt loginUser = (MemberExt)auth.getPrincipal();
        
        board.setUserNo(loginUser.getUserNo());
        board.setBoardTitle(title);    
        board.setBoardContent(content); 
        board.setGameCode(tempGameCode);     
        board.setCategoryNo(tempCategoryNo); 
        
        String savePath = session.getServletContext().getRealPath("/resources/upload/board/");
        
        int result = boardService.insertBoard(board, upFiles, savePath);
        
        session.removeAttribute("tempGameCode");
        session.removeAttribute("tempCategoryNo");
        session.removeAttribute("tempBoardType");

        if(result > 0) {
            ra.addFlashAttribute("message", "게시글이 성공적으로 등록되었습니다.");
            return "redirect:/board/" + boardType + "_" + gameCode;
        } else {
            ra.addFlashAttribute("message", "게시글 등록에 실패했습니다.");
            return "redirect:/";
        }
    }

    // ==========================================
    //  새로 추가된 기능: 수정 & 삭제 로직 
    // ==========================================

    // 1. 게시글 수정 페이지 띄우기 (본인 확인)
    @GetMapping("/edit")
    public String editBoardForm(
            @RequestParam("boardNo") int boardNo,
            Authentication auth,
            RedirectAttributes ra,
            Model model) {
        
        if (auth == null || !auth.isAuthenticated()) {
            ra.addFlashAttribute("message", "로그인 후 이용 가능합니다.");
            return "redirect:/member/login";
        }

        BoardExt board = boardService.selectBoard(boardNo);
        MemberExt loginUser = (MemberExt)auth.getPrincipal();

        // 🚨 작성자와 로그인한 유저가 다르면 쫓아냄!
        if (board == null || board.getUserNo() != loginUser.getUserNo()) {
            ra.addFlashAttribute("message", "잘못된 접근이거나 수정 권한이 없습니다.");
            return "redirect:/board/view?boardNo=" + boardNo;
        }

        model.addAttribute("board", board);
        return "board/board_edit"; // JSP 이름은 수정용 파일명에 맞게 변경하세요!
    }

    // 2. 게시글 실제 수정 처리
    @PostMapping("/edit")
    public String updateBoard(
            Board board,
            @RequestParam(value="upFile", required=false) List<MultipartFile> upFiles,
            Authentication auth,
            HttpSession session,
            RedirectAttributes ra) {
        
        if (auth == null || !auth.isAuthenticated()) {
            return "redirect:/member/login";
        }

        // DB에 업데이트 요청 (BoardService에 updateBoard 구현 필요)
        String savePath = session.getServletContext().getRealPath("/resources/upload/board/");
        // int result = boardService.updateBoard(board, upFiles, savePath); 
        
        // 일단 무조건 성공이라 가정 (추후 Service 작업 시 위 주석 해제)
        int result = 1;

        if (result > 0) {
            ra.addFlashAttribute("message", "게시글이 수정되었습니다.");
        } else {
            ra.addFlashAttribute("message", "수정 실패!");
        }

        // 수정 완료 후 다시 상세 페이지로 이동
        return "redirect:/board/view?boardNo=" + board.getBoardNo();
    }

    // 3. 게시글 삭제 처리
    @GetMapping("/delete")
    public String deleteBoard(
            @RequestParam("boardNo") int boardNo,
            Authentication auth,
            RedirectAttributes ra) {
        
        if (auth == null || !auth.isAuthenticated()) {
            ra.addFlashAttribute("message", "로그인 후 이용 가능합니다.");
            return "redirect:/member/login";
        }

        BoardExt board = boardService.selectBoard(boardNo);
        MemberExt loginUser = (MemberExt)auth.getPrincipal();

        // 🚨 본인 글인지 다시 한번 철저히 검사!
        if (board == null || board.getUserNo() != loginUser.getUserNo()) {
            ra.addFlashAttribute("message", "권한이 없습니다.");
            return "redirect:/";
        }

        // DB에서 삭제 요청 (BoardService에 deleteBoard 구현 필요)
        // int result = boardService.deleteBoard(boardNo);
        int result = 1; // 임시

        if(result > 0) {
            ra.addFlashAttribute("message", "게시글이 삭제되었습니다.");
            
            // 삭제 후 목록으로 돌아가기 위해 게시판 타입과 게임 코드를 소문자로 변환하여 조립
            String type = board.getBoardType() != null && board.getBoardType().equals("자유") ? "free" : "strategy";
            String code = board.getGameCode().toLowerCase();
            return "redirect:/board/" + type + "_" + code;
        } else {
            ra.addFlashAttribute("message", "삭제 실패했습니다.");
            return "redirect:/board/view?boardNo=" + boardNo;
        }
    }

    @PostMapping("/addLike")
    @ResponseBody
    public Map<String, Object> addLike(
            @RequestParam("boardNo") int boardNo, 
            Authentication auth) {
        
        Map<String, Object> response = new HashMap<>();

        if (auth == null || !auth.isAuthenticated()) {
            response.put("status", "error");
            response.put("message", "로그인 후 이용 가능합니다.");
            return response;
        }

        MemberExt loginUser = (MemberExt) auth.getPrincipal();
        int userNo = loginUser.getUserNo();

        // 서비스 호출!
        int result = boardService.insertBoardLike(boardNo, userNo);

        if (result == -1) {
            // 이미 공감한 경우
            response.put("status", "already");
            response.put("message", "이미 공감한 게시글입니다.");
        } else {
            // 성공적으로 공감된 경우
            response.put("status", "success");
            response.put("newLikeCount", result);
        }
        
        return response;
    }

    // 1. 댓글 목록 불러오기 (화면 이동 없음!)
    @ResponseBody
    @GetMapping(value = "/reply/list", produces = "application/json; charset=UTF-8")
    public List<Reply> selectReplyList(int boardNo) {
        // 매퍼의 selectReplyList 호출
        return boardService.selectReplyList(boardNo);
    }

    // 2. 댓글 작성하기 (화면 이동 없음!)
    @ResponseBody
    @PostMapping("/reply/insert")
    public String insertReply(Reply reply, Authentication auth) {
        // 비로그인 사용자가 댓글 달려고 할 때 방어
        if (auth == null || !auth.isAuthenticated()) {
            return "login"; 
        }
        
        // 로그인한 유저 정보 꺼내서 세팅
        MemberExt loginUser = (MemberExt)auth.getPrincipal();
        reply.setUserNo(loginUser.getUserNo());
        
        // 매퍼의 insertReply 호출
        int result = boardService.insertReply(reply);
        
        return result > 0 ? "success" : "fail";
    }    
}