package com.semi.spring.lol.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.semi.spring.lol.model.service.LolService;
import com.semi.spring.lol.model.vo.ChampionVO;

@Controller
@RequestMapping("/lol")
public class LolController {
	private LolService lolService;

	@GetMapping("/main")
	public String lol_main() {
		return "lol/lol_main";
	}
	
	@GetMapping("/hero")
	public String lol_hero(Model model) {
		// 1. DB에서 챔피언 리스트 가져오기
        List<ChampionVO> champList = lolService.selectAllChampions();
        
        // 2. JSP로 데이터 전달
        model.addAttribute("champList", champList);
        
        // 3. 롤 페이지(JSP) 리턴
        return "lol/main";
	}
	
	@GetMapping("/item")
	public String lol_item() {
		return "lol/lol_item_info";
	}
	
	@GetMapping("/rune")
	public String lol_rune() {
		return "lol/lol_rune_info";
	}
	
	@GetMapping("/box")
	public String lol_box() {
		return "lol/box";
	}
	
}
