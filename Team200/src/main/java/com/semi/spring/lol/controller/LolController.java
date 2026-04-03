package com.semi.spring.lol.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.semi.spring.board.model.service.BoardService;
import com.semi.spring.board.model.vo.Board;
import com.semi.spring.board.model.vo.GameInfoReply;
import com.semi.spring.common.model.vo.PageInfo;
import com.semi.spring.common.template.Pagination;
import com.semi.spring.lol.model.dao.LolDao;
import com.semi.spring.lol.model.service.LolService;
import com.semi.spring.lol.model.vo.ChampionVO;
import com.semi.spring.lol.model.vo.LolItemVO;
import com.semi.spring.lol.model.vo.RuneVO;
import com.semi.spring.lol.model.vo.TalentVO;
import com.semi.spring.security.model.vo.MemberExt;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/lol")
@Slf4j
@RequiredArgsConstructor
public class LolController {
    
    // 💡 수정: @Autowired 혼용 대신 private final로 통일하여 @RequiredArgsConstructor 효과 극대화!
    private final LolDao lolDao;
    private final LolService lolService;
    private final BoardService boardService;

    @GetMapping("/board/{categoryNo}")
    // categoryNo = 자유 게시판 (N?) , 공략 게시판(S?)
    public String lolBoard(@PathVariable("categoryNo") String categoryNo,
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage, Model model,
            @RequestParam Map<String, Object> paramMap) {

        paramMap.put("categoryNo", categoryNo);

        int boardLimit = 10;
        int pageLimit = 10;
        int listCount = boardService.selectListCount(paramMap);

        PageInfo pi = Pagination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
        log.debug("pi : {}", pi);
        paramMap.put("pi", pi);

        List<Board> list = boardService.selectList(paramMap);
        model.addAttribute("list", list);
        model.addAttribute("pi", pi);

        return "/board/board_view"; // lol/board/{categoryNo}?currentPage=1
    }

    // 💡 수정: @RequestMapping 대신 명시적인 @GetMapping으로 통일!
    @GetMapping("/hero_main")
    public String lol_hero(Model model) {
        // 1. DB에서 챔피언 리스트 가져오기
        List<ChampionVO> champList = lolService.selectAllChampions();

        // 2. JSP로 데이터 전달
        model.addAttribute("champList", champList);

        // 3. 롤 페이지(JSP) 리턴
        return "lol/lol_hero_main";
    }

    @GetMapping("/hero_main/hero_info")
    public String lol_hero_info(@RequestParam("champNo") int champNo, Model model) {
        // 1. 서비스 호출하여 챔피언 1명의 상세 정보 가져오기
        ChampionVO champ = lolService.getChampDeta(champNo);

        // 2. 모델에 담기
        model.addAttribute("champ", champ);

        return "lol/lol_hero_info";
    }

    @GetMapping("/item") // 주소창에 /lol/item 이라고 쳤을 때 실행됩니다.
    public String lolItemPage(Model model) {

        // 💡 수정: System.out.println 대신 @Slf4j의 log.info 사용!
        log.info("=== 아이템 페이지 요청 들어옴 ===");

        // 1. DAO를 통해 DB에 있는 아이템 목록을 전부 가져옵니다.
        List<LolItemVO> itemList = lolDao.selectAllItems();

        log.info("가져온 아이템 개수: {}개", itemList.size());

        // 2. 가져온 리스트를 "itemList"라는 이름표를 붙여서 JSP로 보냅니다.
        model.addAttribute("itemList", itemList);

        // 3. 아이템 화면 JSP 파일의 경로를 적어줍니다.
        return "lol/lol_item_info";
    }

    @GetMapping("/rune")
    public String lol_rune(Model model) {
        log.info("=== 룬 페이지 요청 들어옴 ===");
        
        // 1. RUNE_INFO 테이블에서 '정밀', '지배' 등 5개 빌드 정보 가져오기
        List<RuneVO> runeList = lolService.selectAllRunes();
        
        // 2. JSP로 데이터 전달
        model.addAttribute("runeList", runeList);
        
        return "lol/lol_rune_info";
    }

    // [추가] 특정 룬 빌드를 클릭했을 때 해당 특성(TALENT_INFO) 목록을 반환 (AJAX 전용)
    @ResponseBody
    @GetMapping(value="/runes/talents", produces="application/json; charset=UTF-8")
    public List<TalentVO> getTalentList(@RequestParam("runeNo") int runeNo) {
        log.info("=== {}번 룬의 특성 목록 요청 ===", runeNo);
        
        // 해당 룬 번호(FK)를 가진 모든 특성(Talent) 조회
        List<TalentVO> talentList = lolService.selectTalentsByRune(runeNo);
        
        // JSON 문자열로 변환하여 응답
        return talentList;
    }

    @GetMapping("/box")
    public String lol_box() {
        return "lol/box";
    }

    // ==========================================================
    // ✨ [신규 추가] 챔피언 정보 페이지 전용 댓글 기능
    // ==========================================================

    // 1. 롤 챔피언 댓글 목록 불러오기 (AJAX)
    @GetMapping("/replyList")
    @ResponseBody
    public List<GameInfoReply> selectChampReplyList(@RequestParam("targetNo") int targetNo) {
        
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("gameCode", "LOL"); // 서버에서 'LOL' 강제 세팅 (보안)
        paramMap.put("targetNo", targetNo); // JSP에서 넘어온 챔피언 번호
        
        return boardService.selectInfoReplies(paramMap);
    }

    // 2. 롤 챔피언 댓글 등록하기 (AJAX)
    @PostMapping("/insertReply")
    @ResponseBody
    public String insertChampReply(@ModelAttribute GameInfoReply reply, Authentication auth) {
        
        // 시큐리티 로그인 체크
        if (auth == null) {
            return "login"; 
        }
        
        // 로그인한 유저 PK 세팅
        int userNo = ((MemberExt) auth.getPrincipal()).getUserNo();
        reply.setUserNo(userNo);
        reply.setGameCode("LOL"); // 서버에서 'LOL' 강제 세팅
        
        int result = boardService.insertInfoReply(reply);
        
        return (result > 0) ? "success" : "fail";
    }
    
    /**
     * 3. 롤 챔피언 댓글 삭제하기 (AJAX)
     */
    @PostMapping("/deleteReply")
    @ResponseBody
    public String deleteChampReply(@RequestParam("infoReplyNo") int infoReplyNo, Authentication auth) {
        
        if (auth == null) {
            return "login"; // 비로그인 상태
        }
        
        // 1. 현재 로그인한 사람 번호 세팅
        int userNo = ((MemberExt) auth.getPrincipal()).getUserNo();
        
        // ✨ 2. 관리자 여부 확인 (스프링 시큐리티 권한 체크)
        boolean isAdmin = auth.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .anyMatch(role -> role.equals("ROLE_ADMIN") || role.equals("ADMIN"));
        
        GameInfoReply reply = new GameInfoReply();
        reply.setInfoReplyNo(infoReplyNo); // 지울 댓글 번호
        reply.setUserNo(userNo);           // 로그인한 유저의 진짜 번호 세팅
        
        // ✨ 3. 관리자 깃발 꽂기! (매퍼에서 이 깃발을 보고 본인 검사를 패스함)
        reply.setAdmin(isAdmin); 
        
        int result = boardService.deleteInfoReply(reply);
        
        return (result > 0) ? "success" : "fail";
    }
    // ==========================================================
    
}