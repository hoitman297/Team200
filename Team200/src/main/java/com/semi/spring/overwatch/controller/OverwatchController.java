package com.semi.spring.overwatch.controller;



import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.core.io.ResourceLoader;
import org.springframework.security.core.Authentication;
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
import com.semi.spring.overwatch.model.service.OverwatchService;
import com.semi.spring.overwatch.model.vo.HeroSkillsVO;
import com.semi.spring.overwatch.model.vo.HeroSkinVO;
import com.semi.spring.overwatch.model.vo.HeroVO;
import com.semi.spring.security.model.vo.MemberExt;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/ow") 
@Slf4j
@RequiredArgsConstructor
public class OverwatchController {

	private final BoardService boardService;
	private final ResourceLoader resourceLoader;
	private final ServletContext application;
	
	private final OverwatchService service;

//	@GetMapping("/main")
//	public String overwatch_main() {
//		return "overwatch/overwatch_main";
//	}

	@GetMapping("/board/{categoryNo}")


	// categoryNo = 자유 게시판 (N?) , 공략 게시판(S?)
	public String overwatchBoard(@PathVariable("categoryNo") String categoryNo,
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

		return null; // overwatch/board/{categoryNo}?currentPage=1
	}

	@GetMapping("/hero_main")
	public String overwatch_hero_main(Model model) {

		List<HeroVO> heroList = service.selectHeroList();

		// JSP에서 ${heroList}로 쓸 수 있게 담아줌
		model.addAttribute("heroList", heroList);
		return "overwatch/overwatch_hero_main";
	}

	@GetMapping("/hero_main/hero_info")
	public String overwatch_hero_info(@RequestParam("heroNo") int heroNo, Model model) {
        // DB에서 해당 번호의 영웅 정보와 스킬 정보 조회
        HeroVO hero = service.selectHero(heroNo);
        HeroSkillsVO skills = service.selectHeroSkills(heroNo);
        List<HeroSkinVO> skinList = service.getHeroSkinList(heroNo);
        // JSP에서 ${hero}, ${skills}로 쓸 수 있게 담아줌
        model.addAttribute("hero", hero);
        model.addAttribute("skills", skills);
        model.addAttribute("skinList", skinList);
		return "overwatch/overwatch_hero_info";
	}

	@GetMapping("/box")
	public String overwatch_box() {
		return "overwatch/box";
	}

	// ==========================================================
    // 🔫 영웅 정보 페이지 전용 댓글(팁) 기능 (AJAX)
    // ==========================================================

    // 1. 영웅 댓글 목록 불러오기
    @GetMapping("/replyList")
    @ResponseBody
    public List<GameInfoReply> selectHeroReplyList(@RequestParam("targetNo") int targetNo) {
        
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("gameCode", "OW"); // ✨ 오버워치니까 무조건 'OW' 강제 세팅!
        paramMap.put("targetNo", targetNo); 
        
        return boardService.selectInfoReplies(paramMap);
    }

    // 2. 영웅 댓글 등록하기
    @PostMapping("/insertReply")
    @ResponseBody
    public String insertHeroReply(@ModelAttribute GameInfoReply reply, Authentication auth) {
        
        if (auth == null) {
            return "login"; 
        }
        
        int userNo = ((MemberExt) auth.getPrincipal()).getUserNo();
        reply.setUserNo(userNo);
        reply.setGameCode("OW"); // ✨ 'OW' 강제 세팅
        
        int result = boardService.insertInfoReply(reply);
        
        return (result > 0) ? "success" : "fail";
    }

    // 3. 영웅 댓글 삭제하기
    @PostMapping("/deleteReply")
    @ResponseBody
    public String deleteHeroReply(@RequestParam("infoReplyNo") int infoReplyNo, Authentication auth) {
        
        if (auth == null) {
            return "login";
        }
        
        int userNo = ((MemberExt) auth.getPrincipal()).getUserNo();
        
        GameInfoReply reply = new GameInfoReply();
        reply.setInfoReplyNo(infoReplyNo); 
        reply.setUserNo(userNo); // 본인 글만 삭제할 수 있도록 세팅
        reply.setGameCode("OW");
        
        int result = boardService.deleteInfoReply(reply);
        
        return (result > 0) ? "success" : "fail";
    }
}
