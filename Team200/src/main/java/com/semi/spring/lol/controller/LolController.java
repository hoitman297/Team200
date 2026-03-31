package com.semi.spring.lol.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.semi.spring.board.model.service.BoardService;
import com.semi.spring.board.model.vo.Board;
import com.semi.spring.common.model.vo.PageInfo;
import com.semi.spring.common.template.Pagination;
import com.semi.spring.lol.model.dao.LolDao;
import com.semi.spring.lol.model.service.LolService;
import com.semi.spring.lol.model.vo.ChampionVO;
import com.semi.spring.lol.model.vo.LolItemVO;
import com.semi.spring.lol.model.vo.RuneVO;
import com.semi.spring.lol.model.vo.TalentVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/lol")
@Slf4j
@RequiredArgsConstructor
public class LolController {
	
	@Autowired
    private LolDao lolDao;
	
	private final LolService lolService;
	private final BoardService boardService;
	private final ResourceLoader resourceLoader;
	private final ServletContext application;

//	@GetMapping("/main")
//	public String lol_main() {
//		return "lol/lol_main";
//	}

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
		// 아직 수정중
	}

	@RequestMapping("/hero_main")
	public String lol_hero(Model model) {
		// 1. DB에서 챔피언 리스트 가져오기
		List<ChampionVO> champList = lolService.selectAllChampions();

		// 2. JSP로 데이터 전달
		model.addAttribute("champList", champList);

		// 3. 롤 페이지(JSP) 리턴
		return "lol/lol_hero_main";
	}

	// LolController.java 수정 제안
	@GetMapping("/hero_main/hero_info")
	public String lol_hero_info(@RequestParam("champNo") int champNo, Model model) {
		// 1. 서비스 호출하여 챔피언 1명의 상세 정보 가져오기
		ChampionVO champ = lolService.getChampDeta(champNo);

		// 2. 모델에 담기
		model.addAttribute("champ", champ);

		return "lol/lol_hero_info";
	}

	@GetMapping("/item") // 주소창에 /lol/item 이라고 쳤을 때 실행됩니다. (주소는 맞게 수정해 주세요!)
	public String lolItemPage(Model model) {

		System.out.println("=== 아이템 페이지 요청 들어옴 ===");

		// 1. DAO를 통해 DB에 있는 아이템 목록을 전부 가져옵니다.
		List<LolItemVO> itemList = lolDao.selectAllItems();

		System.out.println("가져온 아이템 개수: " + itemList.size() + "개");

		// 2. 가져온 리스트를 "itemList"라는 이름표를 붙여서 JSP로 보냅니다.
		// (JSP에서 <c:forEach items="${itemList}"> 로 기다리고 있는 바로 그 이름입니다!)
		model.addAttribute("itemList", itemList);

		// 3. 아이템 화면 JSP 파일의 경로를 적어줍니다.
		// (WEB-INF/views/lol/item.jsp 파일을 띄워준다고 가정)
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

}