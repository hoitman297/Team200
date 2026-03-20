package com.semi.spring.lol.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/lol")
public class LolController {
	
	@GetMapping("/main")
	public String lol_main() {
		return "lol/lol_main";
	}
	
	@GetMapping("/hero")
	public String lol_hero() {
		return "lol/lol_hero_info";
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
