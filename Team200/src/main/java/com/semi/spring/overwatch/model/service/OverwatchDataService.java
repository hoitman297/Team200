package com.semi.spring.overwatch.model.service;

import javax.annotation.PostConstruct;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.semi.spring.overwatch.model.dao.OverwatchDao;
import com.semi.spring.overwatch.model.vo.HeroSkillsVO;
import com.semi.spring.overwatch.model.vo.HeroSkinVO;
import com.semi.spring.overwatch.model.vo.HeroVO;

@Service
public class OverwatchDataService {

	@Autowired
	private OverwatchDao overdao;

	@PostConstruct
	public void init() {
		int count = overdao.checkHeroCount();
		if (count == 0) {
			System.out.println("=== [시작] DB가 비어있어 데이터를 수집합니다 ===");
			new Thread(() -> updateHeroData()).start();
		} else {
			// 테스트를 위해 강제로 실행하고 싶다면 아래 주석을 해제하세요.
			// new Thread(() -> updateHeroData()).start();
			System.out.println("=== [건너뜀] 이미 데이터가 존재합니다. ===");
		}
	}

	public void updateHeroData() {
		try {
			RestTemplate restTemplate = new RestTemplate();
			ObjectMapper objectMapper = new ObjectMapper();

			String listUrl = "https://overfast-api.tekrop.fr/heroes?locale=ko-kr";
			String listJson = restTemplate.getForObject(listUrl, String.class);
			JsonNode heroArray = objectMapper.readTree(listJson);

			for (JsonNode basicNode : heroArray) {
				String heroKey = basicNode.get("key").asText();
				try {
					String detailUrl = "https://overfast-api.tekrop.fr/heroes/" + heroKey + "?locale=ko-kr";
					String detailJson = restTemplate.getForObject(detailUrl, String.class);
					JsonNode detailNode = objectMapper.readTree(detailJson);

					// --- [1단계] HERO_INFO 데이터 세팅 및 안전 검사 ---
					String heroName = detailNode.path("name").asText("");

					if (heroName.isEmpty()) {
						continue;
					}

					HeroVO hero = new HeroVO();
					hero.setHeroName(heroName);
					hero.setHeroIntro(detailNode.path("description").asText("설명 없음"));

					// 역할군 한글 변환
					String apiRole = detailNode.path("role").asText("unknown").toLowerCase();
					String krRole = apiRole.equals("tank") ? "탱커"
							: apiRole.equals("damage") ? "딜러" : apiRole.equals("support") ? "힐러" : apiRole;
					hero.setHeroPosition(krRole);

					hero.setHeroImg(detailNode.path("portrait").asText(""));
					hero.setHeroHp(detailNode.path("hitpoints").path("total").asInt(200));

					// 영웅 정보 DB Insert (MyBatis에서 useGeneratedKeys="true" 설정 필수)
					overdao.insertHero(hero);
					int currentHeroNo = hero.getHeroNo();

					// --- [2단계] 스킬 및 스킨 수집 ---
					saveHeroSkills(currentHeroNo, detailNode.get("abilities"));
					scrapeHeroSkins(currentHeroNo, heroKey);

					// --- [3단계] 차단 방지를 위한 랜덤 지연 ---
					long delay = (long) (Math.random() * 3000) + 3000;
					Thread.sleep(delay);

				} catch (org.springframework.dao.DuplicateKeyException e) {
					System.out.println(">>> [" + heroKey + "] 이미 존재하는 데이터이므로 스킵합니다.");
				} catch (Exception e) {
					System.err.println(">>> [" + heroKey + "] 개별 영웅 처리 에러: " + e.getMessage());
				}
			}
			System.out.println("=== 모든 데이터 수집 프로세스 종료 ===");
		} catch (Exception e) {
			System.err.println("=== 전체 프로세스 치명적 에러: " + e.getMessage());
			e.printStackTrace();
		}
	}

	private void saveHeroSkills(int heroNo, JsonNode abilities) {
		HeroSkillsVO skills = new HeroSkillsVO();
		skills.setHeroNo(heroNo);
		for (int i = 0; i < abilities.size(); i++) {
			JsonNode abil = abilities.get(i);
			String n = abil.get("name").asText();
			String d = abil.get("description").asText();
			String img = abil.get("icon").asText();
			if (i == 0) {
				skills.setSkillLclickName(n);
				skills.setSkillLclickDesc(d);
				skills.setSkillLclickImg(img);
			} else if (i == 1) {
				skills.setSkillShiftName(n);
				skills.setSkillShiftDesc(d);
				skills.setSkillShiftImg(img);
			} else if (i == 2) {
				skills.setSkillEName(n);
				skills.setSkillEDesc(d);
				skills.setSkillEImg(img);
			} else if (i == abilities.size() - 1) {
				skills.setSkillQName(n);
				skills.setSkillQDesc(d);
				skills.setSkillQImg(img);
			} else {
				skills.setSkillRclickName(n);
				skills.setSkillRclickDesc(d);
				skills.setSkillRclickImg(img);
			}
		}
		overdao.insertHeroSkills(skills);
	}

	public void scrapeHeroSkins(int heroNo, String heroKey) {
		String wikiName = convertToWikiName(heroKey);
		String targetUrl = "https://overwatch.fandom.com/wiki/" + wikiName + "/Cosmetics";

		try {
			// ⭐ [우회 핵심 적용] AllOrigins 무료 프록시 서버를 통해 접속 (IP 차단 및 클라우드플레어 우회)
			String proxyUrl = "https://api.allorigins.win/raw?url=" + java.net.URLEncoder.encode(targetUrl, "UTF-8");

			// 프록시 서버를 거치기 때문에 타임아웃을 30초(30000ms)로 넉넉하게 잡습니다.
			Document doc = Jsoup.connect(proxyUrl)
					.userAgent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36")
					.header("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8")
					.header("Accept-Language", "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7")
					.timeout(30000) 
					.get();

			Elements skinElements = doc.select("div.wikia-gallery-item, li.gallerybox");

			int count = 0;
			for (Element el : skinElements) {
				String skinName = el.select(".lightbox-caption, .gallerytext").text();
				String skinImg = el.select("img").attr("data-src").isEmpty() ? el.select("img").attr("src")
						: el.select("img").attr("data-src");

				if (!skinName.isEmpty() && skinImg != null && skinImg.contains("static.wikia")) {
					
					// ⭐ [핵심 수정] 원본 고화질 주소 추출 (정규식 사용)
					// "/scale-to-width-down/숫자" 부분만 깔끔하게 제거하여 
					// ?cb=... 파라미터가 포함된 완벽한 원본 링크를 만듭니다.
					skinImg = skinImg.replaceAll("/scale-to-width-down/[0-9]+", "");
                    
                    // (가끔 /smart/width/ 등의 다른 썸네일 포맷이 있을 경우를 대비한 추가 제거)
					skinImg = skinImg.replaceAll("/smart/width/[0-9]+/height/[0-9]+", "");

					HeroSkinVO skin = new HeroSkinVO();
					skin.setHeroNo(heroNo);
					skin.setHeroSkinName(skinName);
					skin.setHeroSkinImg(skinImg);

					overdao.insertHeroSkin(skin);
					count++;
				}
			}
			System.out.println("-> [" + wikiName + "] 스킨 " + count + "개 저장 성공");

		} catch (org.jsoup.HttpStatusException e) {
			System.err.println("!!! [" + wikiName + "] 프록시 접속 에러 (상태코드 " + e.getStatusCode() + ")");
		} catch (Exception e) {
			System.err.println("!!! [" + wikiName + "] 크롤링 실패: " + e.getMessage());
		}
	}

	private String convertToWikiName(String heroKey) {
		if (heroKey == null || heroKey.isEmpty())
			return "";

		// 1. 기본적으로 첫 글자를 대문자로 변환 (예: genji -> Genji)
		String wikiName = heroKey.substring(0, 1).toUpperCase() + heroKey.substring(1);

		// 2. 특수 케이스 하드코딩 (위키 URL 규칙 반영)
		switch (heroKey) {
		case "dva":
			wikiName = "D.Va";
			break;
		case "soldier-76":
			wikiName = "Soldier:_76";
			break; // 세미콜론(:) 주의
		case "wrecking-ball":
			wikiName = "Wrecking_Ball";
			break;
		case "lucio":
			wikiName = "L%C3%BAcio";
			break; // ú 인코딩
		case "torbjorn":
			wikiName = "Torbj%C3%B6rn";
			break; // ö 인코딩
		case "junkrat":
			wikiName = "Junkrat";
			break;
		case "junker-queen":
			wikiName = "Junker_Queen";
			break;
		case "ramattra":
			wikiName = "Ramattra";
			break;
		case "lifeweaver":
			wikiName = "Lifeweaver";
			break;
		case "illari":
			wikiName = "Illari";
			break;
		case "mauga":
			wikiName = "Mauga";
			break;
		case "venture":
			wikiName = "Venture";
			break;
		default:
			// 3. 하이픈(-)이 포함된 다른 이름들 처리 (예: ana-test -> Ana_Test)
			if (heroKey.contains("-")) {
				String[] parts = heroKey.split("-");
				StringBuilder sb = new StringBuilder();
				for (int i = 0; i < parts.length; i++) {
					sb.append(parts[i].substring(0, 1).toUpperCase()).append(parts[i].substring(1));
					if (i < parts.length - 1)
						sb.append("_");
				}                     
				wikiName = sb.toString();
			}
			break;
		}
		return wikiName;
	}
}