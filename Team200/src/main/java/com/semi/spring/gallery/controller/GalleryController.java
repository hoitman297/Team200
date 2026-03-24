package com.semi.spring.gallery.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/gallery")
public class GalleryController {

	// 갤러리
	@RequestMapping("/list")
	public String galleryList() {
        return "gallery/gallery_list"; 
    }
	
	// 갤러리 등록
	@RequestMapping("/write")
	public String galleryWrite() {
        return "gallery/gallery_write"; 
    }
}
