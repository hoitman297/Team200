package com.semi.spring.overwatch.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/overwatch")
@Slf4j
@RequiredArgsConstructor
public class OverwatchController {
	
	@GetMapping("/main")
	public String overwatch_main() {
		return "overwatch/overwatch_main";
	}
	
	@GetMapping("/hero")
	public String overwatch_hero() {
		return "overwatch/overwatch_hero_info";
	}
	
	@GetMapping("/box")
	public String overwatch_box() {
		return "overwatch/box"; 
	}
	
}
