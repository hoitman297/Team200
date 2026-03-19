package com.semi.spring.battleground.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/battleground")
public class BattlegroundController {
	
	@GetMapping("/main")
	public String battleground_main() {
		return "battleground/battle_main";
	}
	
	@GetMapping("/item")
	public String battleground_item() {
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
