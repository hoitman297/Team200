	package com.semi.spring.battleground.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.semi.spring.battleground.model.service.BattlegroundService;
import com.semi.spring.battleground.model.vo.BagItemInfoVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/bg")
@RequiredArgsConstructor // 생성자 주입을 위해 필수
public class BattlegroundController {
	
//	@GetMapping("/main")
//	public String battleground_main() {
//		return "battleground/battle_main";
//	}
	private final BattlegroundService service;
	
	@GetMapping("/item")
	public String battleground_item(
			@RequestParam(value="category", defaultValue="0") int categoryNo, 
			Model model) {
		
		log.info(">>> 배틀그라운드 아이템 조회 요청 (카테고리: {})", categoryNo);
		
		// 1. 카테고리 목록 조회 (사이드바 메뉴용)
		model.addAttribute("categoryList", service.selectCategoryList());
		
		// 2. 아이템 목록 조회 (필터링 적용)
		List<BagItemInfoVO> itemList;
		if(categoryNo == 0) {
			itemList = service.selectAllItemList();
		} else {
			itemList = service.selectItemListByCategory(categoryNo);
		}
		
		model.addAttribute("itemList", itemList);
		model.addAttribute("currentCategory", categoryNo); // 현재 선택된 카테고리 유지용
		
		return "battleground/battle_item_info";
	}
	
	@GetMapping("/map")
	public String battleground_map() {
		return "battleground/battle_map_info";
	}
	
	@GetMapping("/box")
	public String battleground_box() {
		return "battleground/box";
	}
}
