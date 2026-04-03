package com.semi.spring.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.core.io.ResourceLoader;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
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
import com.semi.spring.board.model.vo.Inquiry;
import com.semi.spring.board.model.vo.Patchnote;
import com.semi.spring.board.model.vo.Reply;
import com.semi.spring.board.model.vo.Report;
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

	@GetMapping("/view")
	public String board_view(
	        @RequestParam("boardNo") int boardNo,
	        HttpServletRequest request,
	        HttpServletResponse response,
	        Model model) {
	    
		Cookie[] cookies = request.getCookies();
	    boolean isViewed = false;
	    
	    if (cookies != null) {
	        for (Cookie cookie : cookies) {
	            if (cookie.getName().equals("viewed_board_" + boardNo)) {
	                isViewed = true;
	                break; 
	            }
	        }
	    }
	    
	    if (!isViewed) {
	        boardService.increaseCount(boardNo); // DB 레벨 조회수 +1
	        
	        Cookie newCookie = new Cookie("viewed_board_" + boardNo, "true");
	        newCookie.setMaxAge(60 * 60); 
	        newCookie.setPath("/"); 
	        
	        response.addCookie(newCookie);
	    }
	    
	    BoardExt board = boardService.selectBoard(boardNo);
	    
	    if (board == null) {
	        return "redirect:/";
	    }	
	    
	    model.addAttribute("board", board);
	    return "board/board_view";
	}
        
	// 게임코드 변환 헬퍼 메서드
	private String getDbGameCode(String gameCode) {
	    if (gameCode == null) return "all";
	    
	    // 무조건 대문자로 바꿔서 비교
	    switch(gameCode.toUpperCase()) {
	        case "BATTLEGROUND":
	        case "BG":
	            return "BG";
	        case "OVERWATCH":
	        case "OW":
	            return "OW";
	        case "LOL":
	        case "LEAGUEOFLEGENDS":
	            return "LOL";	
	        case "ALL":
	            return "all";
	        default:
	            return gameCode.toUpperCase();
	    }
	}

    // [헬퍼] DB용 코드 -> 경로용 소문자 ID
    private String getPathGameId(String dbGameCode) {
        if (dbGameCode == null) return "all";
        
        switch(dbGameCode.toUpperCase()) {
            case "BG": return "battleground";
            case "OW": return "overwatch";
            case "LOL": return "lol";
            default: return "all";
        }
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
                           @RequestParam(value="keyword", required=false) String keyword, // ✨ 1. keyword 파라미터 추가
                           @RequestParam Map<String, Object> paramMap, Model model) {
        String dbGameCode = getDbGameCode(gameCode);
        BoardType gameConfig = boardService.getBoardTypeMap(dbGameCode , "자유");
        if (gameConfig == null) return "common/error";
        
        paramMap.put("gameCode", dbGameCode);
        paramMap.put("categoryNo", gameConfig.getCategoryNo());
        
        // ✨ 2. 검색어가 들어왔다면 맵에 안전하게 세팅! (매퍼로 전달됨)
        if (keyword != null && !keyword.trim().isEmpty()) {
            paramMap.put("keyword", keyword.trim());
        }

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
                               @RequestParam(value="keyword", required=false) String keyword, // ✨ 1. keyword 파라미터 추가
                               @RequestParam Map<String, Object> paramMap, Model model) {
        String dbGameCode = getDbGameCode(gameCode);
        BoardType gameConfig = boardService.getBoardTypeMap(dbGameCode , "공략");
        if (gameConfig == null) return "common/error";
        
        paramMap.put("gameCode", dbGameCode);
        paramMap.put("categoryNo", gameConfig.getCategoryNo());
        
        // ✨ 2. 검색어가 들어왔다면 맵에 안전하게 세팅! (매퍼로 전달됨)
        if (keyword != null && !keyword.trim().isEmpty()) {
            paramMap.put("keyword", keyword.trim());
        }

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
        session.removeAttribute("tempBoardType");

        if(result > 0) {
            ra.addFlashAttribute("message", "게시글이 등록되었습니다.");
            return "redirect:/board/" + boardType + "_" + gameCode;
        }
        return "redirect:/";
    }

    // ================= [수정 모드] 게시글 수정 폼 이동 =================
    @GetMapping("/edit")
    public String editBoardForm(@RequestParam("boardNo") int boardNo, Authentication auth, RedirectAttributes ra, Model model, HttpSession session) {
        
        BoardExt board = boardService.selectBoard(boardNo);
        
        if (auth == null) return "redirect:/member/login";
        MemberExt loginUser = (MemberExt)auth.getPrincipal();
        
        // 권한 체크
        if (board == null || board.getUserNo() != loginUser.getUserNo()) {
            ra.addFlashAttribute("message", "수정 권한이 없습니다.");
            return "redirect:/board/view?boardNo=" + boardNo;
        }
        
        // 1. 게시판 타입 판별 (자유/공략)
        String type = (board.getCategoryName() != null && board.getCategoryName().contains("공략")) ? "strategy" : "free";
        
        // 2. 경로용 게임 ID 판별 (BG -> battleground 등)
        String gameId = getPathGameId(board.getGameCode());
        
        // 3. JSP 재활용을 위한 속성 세팅
        model.addAttribute("board", board); // 이게 있어야 JSP에서 isEdit가 true가 됨
        model.addAttribute("gameId", gameId);
        model.addAttribute("gameName", (board.getGameCode().equals("BG") ? "배틀그라운드" : board.getGameCode().equals("OW") ? "오버워치" : "리그 오브 레전드"));
        
        // 4. Form의 action 결정을 위한 세션 세팅
        session.setAttribute("tempGameCode", board.getGameCode());
        session.setAttribute("tempCategoryNo", board.getCategoryNo());
        session.setAttribute("tempBoardType", type);
        
        // 5. 해당하는 작성 페이지로 리턴 (예: board/strategy_write_battleground)
        return "board/" + type + "_write_" + gameId; 
    }


    // ================= [수정 완료] 게시글 업데이트 처리 =================
    @PostMapping("/update") 
    public String updateBoard(Board board, 
                             @RequestParam(value="upFile", required=false) List<MultipartFile> upFiles,
                             @RequestParam(value="deleteFileNos", required=false) List<Integer> deleteFileNos,
                             Authentication auth, HttpSession session, RedirectAttributes ra) {
        
        if (auth == null) return "redirect:/member/login";
        
        String savePath = session.getServletContext().getRealPath("/resources/upload/board/");
        
        // 서비스 단에서 DB 수정 및 파일 삭제/추가 로직 처리
        int result = boardService.updateBoard(board, upFiles, deleteFileNos, savePath);
        
        if(result > 0) {
            ra.addFlashAttribute("message", "게시글이 수정되었습니다.");
        } else {
            ra.addFlashAttribute("message", "수정 실패하였습니다.");
        }
        
        // 세션 임시 변수 정리
        session.removeAttribute("tempGameCode");
        session.removeAttribute("tempCategoryNo");
        session.removeAttribute("tempBoardType");
        
        return "redirect:/board/view?boardNo=" + board.getBoardNo();
    }


    // 게시글 삭제 처리
    @GetMapping("/delete")
    public String deleteBoard(@RequestParam("boardNo") int boardNo, Authentication auth, RedirectAttributes ra) {
        
        BoardExt board = boardService.selectBoard(boardNo);
        if (auth == null) return "redirect:/member/login";
        MemberExt loginUser = (MemberExt)auth.getPrincipal();
        
        boolean isAdmin = auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
        
        if (board == null || (board.getUserNo() != loginUser.getUserNo() && !isAdmin)) {
            ra.addFlashAttribute("message", "삭제 권한이 없습니다.");
            return "redirect:/";
        }
        
        int result = boardService.deleteBoard(boardNo); 
        
        if(result > 0) {
            ra.addFlashAttribute("message", "게시글이 삭제되었습니다.");
            String type = (board.getCategoryName() != null && board.getCategoryName().contains("공략")) ? "strategy" : "free";
            String gameName = getPathGameId(board.getGameCode());
            
            return "redirect:/board/" + type + "_" + gameName;
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
        if (result == -1) {
            response.put("status", "already");
            response.put("message", "이미 공감한 게시글입니다.");
        } else {
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

        
    // 댓글 삭제
    @ResponseBody
    @PostMapping("/reply/delete")
    public String deleteReply(int replyNo, Authentication auth) {
        
        if (auth == null || !auth.isAuthenticated()) {
            return "login"; 
        }
        
        int userNo = ((MemberExt)auth.getPrincipal()).getUserNo();
        
        boolean isAdmin = auth.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .anyMatch(role -> role.equals("ROLE_ADMIN") || role.equals("ADMIN"));
        
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("replyNo", replyNo);
        paramMap.put("userNo", userNo);
        paramMap.put("isAdmin", isAdmin); 
        
        int result = boardService.deleteReply(paramMap);
        
        return result > 0 ? "success" : "fail";
    }
        
 // 1:1문의 메인
    @GetMapping("/inquiry")
    public String inquiry(@RequestParam(value="game", defaultValue="all") String game,
            @RequestParam(value="cp", defaultValue="1") int cp, 
            Authentication auth, 
            Model model) {
        
        if (auth == null) return "redirect:/member/login";
        MemberExt loginUser = (MemberExt) auth.getPrincipal();
        int userNo = loginUser.getUserNo();
        
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("userNo", userNo);
        
        String dbGameCode = game.equalsIgnoreCase("all") ? "all" : getDbGameCode(game);
        paramMap.put("gameCode", dbGameCode);
        
        int listCount = boardService.selectInquiryCount(paramMap);
        PageInfo pi = Pagination.getPageInfo( listCount,cp, 10, 10);
        List<Inquiry> inquiryList = boardService.selectInquiryList(pi, paramMap);
        
        model.addAttribute("inquiryList", inquiryList);
        model.addAttribute("pi", pi);
        
        model.addAttribute("currentGame", game.toLowerCase());
        
        return "board/user_inquiry";
    }
    
    // 1:1 문의 작성 페이지 이동
    @GetMapping("/inquiryWrite")
    public String inquiryWrite() {
        return "board/user_inquiry_write";
    }
    
    @PostMapping("/inquiry/insert")
    public String insertInquiry(Inquiry inquiry, Authentication auth, RedirectAttributes ra) {
        
        if (auth == null) return "redirect:/member/login";
        MemberExt loginUser = (MemberExt) auth.getPrincipal();
        inquiry.setUserNo(loginUser.getUserNo());
        inquiry.setUserName(loginUser.getUserName());
        
        String normalizedCode = getDbGameCode(inquiry.getGameCode());
        inquiry.setGameCode(normalizedCode);
        
        int result = boardService.insertInquiry(inquiry);
        
        if(result > 0) {
            ra.addFlashAttribute("message", "문의가 성공적으로 접수되었습니다.");
            String pathId = getPathGameId(normalizedCode);
            return "redirect:/board/inquiry?game=" + pathId;
        } else {
            ra.addFlashAttribute("message", "문의 접수에 실패했습니다.");
            return "redirect:/board/inquiryWrite";
        }
    }    
    
 // 문의 상세 보기
    @GetMapping("/inquiryView")
    public String board_inquiryView(@RequestParam("boardNo") int boardNo,
                                    @RequestParam(value="game", defaultValue="all") String game,
                                    Authentication auth,
                                    Model model,
                                    RedirectAttributes ra) {
        
        // 1. 로그인 체크
        if (auth == null) {
            ra.addFlashAttribute("message", "로그인 후 이용 가능합니다.");
            return "redirect:/member/login";
        }
        MemberExt loginUser = (MemberExt) auth.getPrincipal();

        // 2. DB에서 문의글 상세 정보 가져오기 (Service, DAO에 selectInquiryDetail 메서드 필요!)
        Inquiry inquiry = boardService.selectInquiryDetail(boardNo);

        // 3. 보안 체크 (게시글이 없거나, 작성자가 본인이 아닐 경우 튕겨내기)
        if (inquiry == null || inquiry.getUserNo() != loginUser.getUserNo()) {
            ra.addFlashAttribute("message", "조회 권한이 없거나 존재하지 않는 문의입니다.");
            // 돌아갈 때 원래 보던 탭으로 돌려보내는 센스!
            return "redirect:/board/inquiry?game=" + game; 
        }

        // 4. JSP에 데이터 전달
        model.addAttribute("inq", inquiry);
        model.addAttribute("currentGame", game); // "목록으로" 버튼을 눌렀을 때 원래 필터 유지용

        return "board/user_inquiry_view";
    }
    
 // 1:1 문의 삭제 처리
    @GetMapping("/inquiryDelete")
    public String inquiryDelete(@RequestParam("boardNo") int boardNo, 
                                Authentication auth, 
                                RedirectAttributes ra) {
        
        if (auth == null) return "redirect:/member/login";
        MemberExt loginUser = (MemberExt) auth.getPrincipal();
        
        // 1. 혹시 남의 글을 삭제하려고 하는지 DB에서 작성자 확인
        Inquiry inquiry = boardService.selectInquiryDetail(boardNo);
        
        if (inquiry == null || inquiry.getUserNo() != loginUser.getUserNo()) {
            ra.addFlashAttribute("message", "삭제 권한이 없습니다.");
            return "redirect:/board/inquiry";
        }
        
        // 2. 삭제 실행!
        int result = boardService.deleteInquiry(boardNo);
        
        if(result > 0) {
            ra.addFlashAttribute("message", "문의글이 정상적으로 삭제되었습니다.");
        } else {
            ra.addFlashAttribute("message", "삭제에 실패했습니다.");
        }
        
        // 3. 삭제 후 목록으로 (기본 '전체' 탭으로 이동)
        return "redirect:/board/inquiry";
    }
    
 // ================= [신고 처리] 게시글 신고 =================
    @PostMapping("/report")
    @ResponseBody
    public String reportBoard(
            @RequestParam("reportReason") String reportReason,
            @RequestParam("reportDetail") String reportDetail,
            Report report, 
            Authentication auth) {
        
        // 1. 로그인 체크
        if (auth == null || !auth.isAuthenticated()) {
            return "login";
        }
        
        // 2. 로그인 유저 정보 세팅 (MemberExt 사용)
        MemberExt loginUser = (MemberExt) auth.getPrincipal();
        report.setUserNo(loginUser.getUserNo());
        
        // 3. 프론트엔드 데이터와 VO 필드명 불일치 수동 매핑
        report.setReportType(reportReason);
        report.setReportContent(reportDetail);
        
        // 4. 서비스 호출 (Service와 DAO에 insertReport 메서드가 있어야 합니다!)
        int result = boardService.insertReport(report);
        
        return result > 0 ? "success" : "fail";
    }

    // ================= [신고 처리] 댓글 신고 =================
    @PostMapping("/reply/report")
    @ResponseBody
    public String reportReply(
            @RequestParam("reportReason") String reportReason,
            @RequestParam("reportDetail") String reportDetail,
            Report report, 
            Authentication auth) {
        
        // 1. 로그인 체크
        if (auth == null || !auth.isAuthenticated()) {
            return "login";
        }
        
        // 2. 로그인 유저 정보 세팅
        MemberExt loginUser = (MemberExt) auth.getPrincipal();
        report.setUserNo(loginUser.getUserNo());
        
        // 3. 수동 매핑
        report.setReportType(reportReason);
        report.setReportContent(reportDetail);
        
        // 4. 서비스 호출
        int result = boardService.insertReport(report);
        
        return result > 0 ? "success" : "fail";
    }
    
 // ✨ 누군가 꼬리표 없이 /patchnote 로 들어오면 /patchnote_all 로 토스!
    @GetMapping("/patchnote")
    public String patchnoteRedirect() {
        return "redirect:/board/patchnote_all";
    }
    
    @GetMapping("/patchnote_{gameCode}")
    public String patchnoteGame(
            @PathVariable("gameCode") String gameCode,
            @RequestParam(value="cp", defaultValue="1") int cp,
            @RequestParam Map<String, Object> paramMap, 
            Model model) {
        
        // 1. URL의 소문자 gameCode를 DB용 대문자로 변환
        // (만약 'all'로 들어오면 'ALL'로 변환되어 Mapper의 <if> 조건에 걸리지 않게 됩니다!)
        String dbGameCode = gameCode.toUpperCase();
        if(dbGameCode.equals("OVERWATCH")) dbGameCode = "OW";
        if(dbGameCode.equals("BATTLEGROUND")) dbGameCode = "BG";
        
        paramMap.put("gameCode", dbGameCode);
        
        // 2. 전체 게시글 수 조회 및 페이징 객체(PageInfo) 생성
        int listCount = boardService.selectPatchnoteCount(paramMap);
        PageInfo pi = Pagination.getPageInfo(listCount, cp, 10, 10);
        
        // 💡 매퍼에서 사용할 offset과 limit 세팅
        int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit() + 1;
        int limit = offset + pi.getBoardLimit() - 1;
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        
        // 3. 패치노트 목록 조회
        List<BoardExt> list = boardService.selectPatchnoteList(paramMap);
        
        // 4. JSP로 데이터 전달
        model.addAttribute("boardList", list);
        model.addAttribute("pi", pi);
        model.addAttribute("gameId", gameCode.toLowerCase()); // JSP 분기용 소문자 원본
        
        // ✨ 우리가 만든 단 1개의 '통합 패치노트 JSP'로 이동!
        return "board/patchnote_main"; 
    }
    
 // ✨ 패치노트 상세 조회 (공통 조회수 증가 로직 탑재!)
    @GetMapping("/patchnoteView")
    public String patchnoteDetail(
            @RequestParam("boardNo") int boardNo, 
            HttpServletRequest request, 
            HttpServletResponse response, 
            Model model) {
        
        // 1. 쿠키 검사: 이 패치노트를 이미 읽었는지 확인
        Cookie[] cookies = request.getCookies();
        boolean isViewed = false;
        
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("viewed_patchnote_" + boardNo)) {
                    isViewed = true;
                    break; 
                }
            }
        }
        
        // 2. 안 읽었던 글이라면 조회수 증가 후 쿠키 굽기!
        if (!isViewed) {
            // ✨ [핵심 수정 포인트] 
            // 기존 전용 메서드 대신, 파라미터 3개를 던지는 공통 메서드를 호출합니다!
            boardService.updateOfficialReadCount("PATCHNOTE", "PATCHNOTE_NO", boardNo); 
            
            Cookie newCookie = new Cookie("viewed_patchnote_" + boardNo, "true");
            newCookie.setMaxAge(60 * 60); // 1시간 유지
            newCookie.setPath("/"); 
            response.addCookie(newCookie);
        }
        
        // 3. 최신 데이터 가져오기
        BoardExt board = boardService.selectPatchnoteDetail(boardNo);
        
        // 4. 만약 삭제되었거나 없는 글이면 메인으로 튕겨내기
        if (board == null) {
            return "redirect:/";
        }   
        
        // 5. JSP로 데이터 토스!
        model.addAttribute("board", board);
        model.addAttribute("gameName", "패치노트");
        
        // 만능 읽기 전용 껍데기 JSP로 이동
        return "board/official_detail"; 
    }
    
 // ✨ 패치노트 상세 조회 (공통 조회수 증가 로직 탑재!)
    @GetMapping("/noticeView")
    public String noticeDetail(
            @RequestParam("boardNo") int boardNo, 
            HttpServletRequest request, 
            HttpServletResponse response, 
            Model model) {
        
        // 1. 쿠키 검사: 이 패치노트를 이미 읽었는지 확인
        Cookie[] cookies = request.getCookies();
        boolean isViewed = false;
        
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("viewed_patchnote_" + boardNo)) {
                    isViewed = true;
                    break; 
                }
            }
        }
        
        // 2. 안 읽었던 글이라면 조회수 증가 후 쿠키 굽기!
        if (!isViewed) {
            // ✨ [핵심 수정 포인트] 
            // 기존 전용 메서드 대신, 파라미터 3개를 던지는 공통 메서드를 호출합니다!
            boardService.updateOfficialReadCount("NOTICE", "NOTICE_NO", boardNo); 
            
            Cookie newCookie = new Cookie("viewed_notice_" + boardNo, "true");
            newCookie.setMaxAge(60 * 60); // 1시간 유지
            newCookie.setPath("/"); 
            response.addCookie(newCookie);
        }
        
        // 3. 최신 데이터 가져오기
        BoardExt board = boardService.selectPatchnoteDetail(boardNo);
        
        // 4. 만약 삭제되었거나 없는 글이면 메인으로 튕겨내기
        if (board == null) {
            return "redirect:/";
        }   
        
        // 5. JSP로 데이터 토스!
        model.addAttribute("board", board);
        model.addAttribute("gameName", "패치노트");
        
        // 만능 읽기 전용 껍데기 JSP로 이동
        return "board/official_detail"; 
    }
    
 // 1. /notice 로 접속하면 /notice_list 로 강제 이동!
    @GetMapping("/notice")
    public String noticeRedirect() {
        return "redirect:/board/notice_list";
    }

    // 2. 공지사항 전체 목록 조회
    @GetMapping("/notice_list")
    public String noticeList(
            @RequestParam(value="cp", defaultValue="1") int cp,
            @RequestParam Map<String, Object> paramMap, 
            Model model) {
        
        // ✨ 공지사항은 게임 구분이 없으므로 gameCode 변환 로직은 싹 뺐습니다!
        
        // 1. 전체 공지사항 개수 조회 및 페이징 객체 생성
        // (boardService.selectNoticeCount 메서드가 필요합니다!)
        int listCount = boardService.selectNoticeCount(paramMap);
        PageInfo pi = Pagination.getPageInfo(listCount, cp, 10, 10);
        
        // 2. 매퍼에서 사용할 offset과 limit 세팅 (오라클용)
        int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit() + 1;
        int limit = offset + pi.getBoardLimit() - 1;
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        
        // 3. 공지사항 목록 조회 (boardService.selectNoticeList 메서드 호출)
        List<BoardExt> list = boardService.selectNoticeList(paramMap);
        
        // 4. JSP로 데이터 전달
        model.addAttribute("boardList", list);
        model.addAttribute("pi", pi);
        model.addAttribute("boardTitle", "공지사항"); // 상단 제목용
        model.addAttribute("gameName", "공지사항");  // 사이드바/헤더용
        model.addAttribute("isNotice", "true");      // 📌 중요: 패치노트의 isPatchnote 처럼 쓰일 깃발!
        
        // 5. 공지사항 전용 목록 JSP로 이동! (패치노트 JSP를 복붙해서 만드시면 됩니다)
        return "board/notice_main"; 
    }
}
