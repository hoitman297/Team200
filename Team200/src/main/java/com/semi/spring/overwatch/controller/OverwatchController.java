package com.semi.spring.overwatch.controller;



import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.semi.spring.board.model.service.BoardService;
import com.semi.spring.board.model.vo.Board;
import com.semi.spring.common.model.vo.PageInfo;
import com.semi.spring.common.template.Pagination;
import com.semi.spring.overwatch.model.service.OverwatchService;
import com.semi.spring.overwatch.model.vo.HeroSkillsVO;
import com.semi.spring.overwatch.model.vo.HeroVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/overwatch")
@Slf4j
@RequiredArgsConstructor
public class OverwatchController {

	private final BoardService boardService;
	private final ResourceLoader resourceLoader;
	private final ServletContext application;
	
	private final OverwatchService service;

	@GetMapping("/main")
	public String overwatch_main() {
		return "overwatch/overwatch_main";
	}

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
        
        // JSP에서 ${hero}, ${skills}로 쓸 수 있게 담아줌
        model.addAttribute("hero", hero);
        model.addAttribute("skills", skills);
		return "overwatch/overwatch_hero_info";
	}

	@GetMapping("/box")
	public String overwatch_box() {
		return "overwatch/box";
	}

}
