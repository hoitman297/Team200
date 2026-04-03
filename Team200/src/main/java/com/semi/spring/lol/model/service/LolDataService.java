package com.semi.spring.lol.model.service;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import javax.annotation.PostConstruct;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.semi.spring.lol.model.dao.LolDao;
import com.semi.spring.lol.model.vo.ChampionVO;
import com.semi.spring.lol.model.vo.LolItemVO;
import com.semi.spring.lol.model.vo.RecommendBuildVO;
import com.semi.spring.lol.model.vo.RuneVO;
import com.semi.spring.lol.model.vo.SkillVO;
import com.semi.spring.lol.model.vo.SkinVO;
import com.semi.spring.lol.model.vo.TalentVO;

@Service
public class LolDataService {

	@Autowired
	private LolDao lolDao;
	private static boolean isInitialized = false;
	
	private boolean isImageUrlValid(String urlString) {
		try {
			java.net.URL url = new java.net.URL(urlString);
			java.net.HttpURLConnection connection = (java.net.HttpURLConnection) url.openConnection();
			connection.setRequestMethod("HEAD");
			connection.setConnectTimeout(1000);
			connection.setReadTimeout(1000);

			int responseCode = connection.getResponseCode();
			return responseCode == 200;
		} catch (Exception e) {
			return false;
		}
	}

	// =========================================================================

	@PostConstruct
	public synchronized void init() { 
		if (isInitialized) {
			return; 
		}
		isInitialized = true; 

		// 1. 챔피언 데이터 체크
		List<ChampionVO> list = lolDao.selectAllChampions();
		if (list == null || list.isEmpty()) {
			System.out.println("=== 롤 챔피언 DB가 비어있어 API 데이터를 가져옵니다 ===");

			new Thread(() -> {
				updateChampionData(); 
				
				System.out.println("=== 챔피언 데이터 저장이 완료되어 추천 빌드 크롤링을 시작합니다 ===");
				updateRecommendedBuilds(); 
			}).start();

		} else {
			System.out.println("=== 이미 " + list.size() + "개의 데이터가 있어 챔피언 업데이트를 건너뜁니다. ===");
			new Thread(() -> updateRecommendedBuilds()).start();
		}
		
		// 2. 아이템 데이터 체크
		List<LolItemVO> itemList = lolDao.selectAllItems();
		if (itemList == null || itemList.isEmpty()) {
			System.out.println("=== 롤 아이템 DB가 비어있어 API 데이터를 가져옵니다 ===");
			new Thread(() -> updateItemData()).start();
		}

		// 3. 룬 데이터 체크
		List<RuneVO> runeList = lolDao.selectAllRunes(); 
		if (runeList == null || runeList.isEmpty()) {
			System.out.println("=== 롤 룬 DB가 비어있어 API 데이터를 가져옵니다 ===");
			new Thread(() -> updateRuneData()).start();
		} else {
			System.out.println("=== 이미 " + runeList.size() + "개의 룬 빌드 데이터가 있습니다. ===");
		}
	}

	// 문자열 길이 안전하게 자르는 헬퍼 메서드 (DB 용량 초과 방지)
	private String truncateString(String text, int maxLength) {
		if (text == null) return null;
		String cleanText = text.replaceAll("<[^>]*>", "").trim(); // HTML 태그 제거
		if (cleanText.length() > maxLength) {
			return cleanText.substring(0, maxLength) + "...";
		}
		return cleanText;
	}

	public void updateChampionData() {
		try {
			RestTemplate restTemplate = new RestTemplate();
			String versionUrl = "https://ddragon.leagueoflegends.com/api/versions.json";
			List<String> versions = restTemplate.getForObject(versionUrl, List.class);
			String latestVersion = versions.get(0);

			System.out.println("=== 최신 롤 패치 버전: " + latestVersion + " ===");

			String baseUrl = "https://ddragon.leagueoflegends.com/cdn/" + latestVersion;
			String listUrl = baseUrl + "/data/ko_KR/champion.json";

			Map<String, Object> response = restTemplate.getForObject(listUrl, Map.class);
			Map<String, Object> data = (Map<String, Object>) response.get("data");

			AtomicInteger insertCount = new AtomicInteger(0);
			ExecutorService executor = Executors.newFixedThreadPool(5);

			System.out.println("=== 🚀 챔피언 데이터 병렬 저장(5개 스레드)을 시작합니다! ===");

			for (String key : data.keySet()) {
				executor.submit(() -> {
					try {
						// [1단계] 챔피언 기본 정보
						Map<String, Object> champInfo = (Map<String, Object>) data.get(key);
						ChampionVO champ = new ChampionVO();
						champ.setChampName((String) champInfo.get("name"));

						List<String> tags = (List<String>) champInfo.get("tags");
						champ.setChampPosition(String.join(", ", tags));

						String intro = (String) champInfo.get("blurb");
						champ.setChampIntro(intro != null ? truncateString(intro, 600) : "소개글이 없습니다.");
						
						String imgUrl = baseUrl + "/img/champion/" + key + ".png";
						champ.setChampImg(imgUrl);

						lolDao.insertChampion(champ);
						int currentChampNo = lolDao.selectChampNoByName(champ.getChampName());

						// [2단계] 챔피언 상세 정보 (스킬/스킨)
						try {
							String detailUrl = baseUrl + "/data/ko_KR/champion/" + key + ".json";
							Map<String, Object> detailRes = restTemplate.getForObject(detailUrl, Map.class);
							Map<String, Object> detailData = (Map<String, Object>) detailRes.get("data");
							Map<String, Object> detail = (Map<String, Object>) detailData.get(key);

							SkillVO skillVO = new SkillVO();
							skillVO.setChampNo(currentChampNo); 

							Map<String, Object> passive = (Map<String, Object>) detail.get("passive");
							skillVO.setSkillPName(truncateString((String) passive.get("name"), 30));
							skillVO.setSkillPDesc(truncateString((String) passive.get("description"), 300));
							Map<String, Object> passiveImgObj = (Map<String, Object>) passive.get("image");
							skillVO.setSkillPImg(baseUrl + "/img/passive/" + passiveImgObj.get("full"));

							List<Map<String, Object>> spells = (List<Map<String, Object>>) detail.get("spells");
							
							skillVO.setSkillQName(truncateString((String) spells.get(0).get("name"), 30));
							skillVO.setSkillQDesc(truncateString((String) spells.get(0).get("description"), 300));
							skillVO.setSkillQImg(baseUrl + "/img/spell/" + ((Map<String, Object>) spells.get(0).get("image")).get("full"));

							skillVO.setSkillWName(truncateString((String) spells.get(1).get("name"), 30));
							skillVO.setSkillWDesc(truncateString((String) spells.get(1).get("description"), 300));
							skillVO.setSkillWImg(baseUrl + "/img/spell/" + ((Map<String, Object>) spells.get(1).get("image")).get("full"));

							skillVO.setSkillEName(truncateString((String) spells.get(2).get("name"), 30));
							skillVO.setSkillEDesc(truncateString((String) spells.get(2).get("description"), 300));
							skillVO.setSkillEImg(baseUrl + "/img/spell/" + ((Map<String, Object>) spells.get(2).get("image")).get("full"));

							skillVO.setSkillRName(truncateString((String) spells.get(3).get("name"), 30));
							skillVO.setSkillRDesc(truncateString((String) spells.get(3).get("description"), 300));
							skillVO.setSkillRImg(baseUrl + "/img/spell/" + ((Map<String, Object>) spells.get(3).get("image")).get("full"));

							lolDao.insertChampionSkills(skillVO);

							List<Map<String, Object>> skins = (List<Map<String, Object>>) detail.get("skins");

							for (Map<String, Object> skinData : skins) {
								try {
									SkinVO skinVO = new SkinVO();
									skinVO.setChampNo(currentChampNo); 

									String skinName = (String) skinData.get("name");
									if ("default".equalsIgnoreCase(skinName)) skinName = "기본";
									
									skinVO.setChampSkinName(truncateString(skinName, 30));

									String skinNum = String.valueOf(skinData.get("num"));
									String skinImgUrl = "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/" + key + "_" + skinNum + ".jpg";

									if (isImageUrlValid(skinImgUrl)) {
										skinVO.setChampSkinImg(skinImgUrl);
										lolDao.insertChampionSkin(skinVO);
									}
								} catch (Exception skinEx) {}
							}
						} catch (Exception detailEx) {
							System.out.println("⚠️ [" + champ.getChampName() + "] 상세 정보 저장 중 오류 발생");
						}

						int currentCount = insertCount.incrementAndGet();
						System.out.println("✅ " + champ.getChampName() + " 저장 완료 (" + currentCount + "/" + data.size() + ")");

					} catch (Exception innerEx) {
						System.out.println("🚨 [" + key + "] 챔피언 기본 정보 저장 중 오류: " + innerEx.getMessage());
					}
				}); 
			} 

			executor.shutdown();
			try {
				executor.awaitTermination(10, TimeUnit.MINUTES);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}

			System.out.println("=== [최종 성공] 총 " + insertCount.get() + "명의 챔피언 처리를 완료했습니다! ===");

		} catch (Exception e) {
			System.out.println("=== [치명적 에러] 챔피언 데이터 초기화 프로세스 자체가 실패했습니다: " + e.getMessage());
			e.printStackTrace();
		}
	}

	public void updateItemData() {
		try {
			RestTemplate restTemplate = new RestTemplate();
			String versionUrl = "https://ddragon.leagueoflegends.com/api/versions.json";
			List<String> versions = restTemplate.getForObject(versionUrl, List.class);
			String latestVersion = versions.get(0);

			System.out.println("=== 아이템 데이터 수집 시작 (버전: " + latestVersion + ") ===");

			String baseUrl = "https://ddragon.leagueoflegends.com/cdn/" + latestVersion;
			String listUrl = baseUrl + "/data/ko_KR/item.json";

			Map<String, Object> response = restTemplate.getForObject(listUrl, Map.class);
			Map<String, Object> data = (Map<String, Object>) response.get("data");

			int insertCount = 0;
			Set<String> processedNames = new HashSet<>();

			for (String key : data.keySet()) {
				try {
					Map<String, Object> itemInfo = (Map<String, Object>) data.get(key);

					if (!itemInfo.containsKey("name")) continue;

					Map<String, Boolean> maps = (Map<String, Boolean>) itemInfo.get("maps");
					if (maps == null || maps.get("11") == null || maps.get("11") == false) continue;

					String itemName = (String) itemInfo.get("name");

					Map<String, Object> goldInfo = (Map<String, Object>) itemInfo.get("gold");
					boolean purchasable = (boolean) goldInfo.get("purchasable");
					int totalPrice = (Integer) goldInfo.get("total");

					List<String> tags = (List<String>) itemInfo.get("tags");
					boolean isWard = tags != null && (tags.contains("Trinket") || tags.contains("Vision"));

					if (!purchasable) continue;
					if (totalPrice == 0 && !isWard) continue;
					if (processedNames.contains(itemName)) continue;

					processedNames.add(itemName);

					LolItemVO itemVO = new LolItemVO();
					itemVO.setItemNo(Integer.parseInt(key));
					itemVO.setItemName(truncateString(itemName, 30));
					itemVO.setItemPrice(totalPrice);

					String plaintext = (String) itemInfo.get("plaintext");
					if (plaintext != null && !plaintext.trim().isEmpty()) {
						itemVO.setItemInfo(truncateString(plaintext, 300));
					} else {
						String desc = (String) itemInfo.get("description");
						itemVO.setItemInfo(truncateString(desc, 300));
					}

					String imgUrl = baseUrl + "/img/item/" + key + ".png";
					itemVO.setItemImg(imgUrl);
					itemVO.setItemTag(tags != null ? truncateString(String.join(",", tags), 150) : "");

					lolDao.insertItem(itemVO);
					insertCount++;
				} catch (Exception ex) {
					// 아이템 개별 에러 발생 시 무시
				}
			}

			System.out.println("=== [성공] 총 " + insertCount + "개의 협곡 아이템 저장 완료 (칼바람 제외) ===");

		} catch (Exception e) {
			System.out.println("=== [에러 발생] 아이템 데이터 업데이트 중지 ===");
			e.printStackTrace();
		}
	}

	public void updateRuneData() {
		try {
			RestTemplate restTemplate = new RestTemplate();
			String versionUrl = "https://ddragon.leagueoflegends.com/api/versions.json";
			List<String> versions = restTemplate.getForObject(versionUrl, List.class);
			String latestVersion = versions.get(0);

			String runeUrl = "https://ddragon.leagueoflegends.com/cdn/" + latestVersion + "/data/ko_KR/runesReforged.json";
			List<Map<String, Object>> runeDataList = restTemplate.getForObject(runeUrl, List.class);

			int runeCount = 0;
			int talentCount = 0;

			for (Map<String, Object> pathMap : runeDataList) {
				try {
					RuneVO rune = new RuneVO();
					rune.setRuneName(truncateString((String) pathMap.get("name"), 30));
					rune.setRuneInfo(truncateString((String) pathMap.get("key"), 60)); 
					rune.setRuneImg("https://ddragon.leagueoflegends.com/cdn/img/" + pathMap.get("icon"));

					lolDao.insertRune(rune);
					int generatedRuneNo = lolDao.selectRuneNoByName(rune.getRuneName()); 
					runeCount++;

					List<Map<String, Object>> slots = (List<Map<String, Object>>) pathMap.get("slots");

					for (Map<String, Object> slot : slots) {
						List<Map<String, Object>> runesInSlot = (List<Map<String, Object>>) slot.get("runes");

						for (Map<String, Object> rObj : runesInSlot) {
							try {
								TalentVO talent = new TalentVO();
								talent.setRuneNo(generatedRuneNo); 
								talent.setTalentName(truncateString((String) rObj.get("name"), 30));
								talent.setTalentInfo(truncateString((String) rObj.get("shortDesc"), 100));
								talent.setTalentImg("https://ddragon.leagueoflegends.com/cdn/img/" + rObj.get("icon"));

								lolDao.insertTalent(talent);
								talentCount++;
							} catch (Exception tx) {}
						}
					}
				} catch (Exception rx) {}
			}
			System.out.println("=== [성공] " + runeCount + "개의 빌드와 " + talentCount + "개의 특성 저장 완료! ===");

		} catch (Exception e) {
			System.err.println("=== [에러] 룬 데이터 수집 중 오류 발생 ===");
			e.printStackTrace();
		}
	}

	public void updateRecommendedBuilds() {
		System.out.println("=== 🚀 추천 빌드 데이터 병렬 크롤링(OP.GG) 시작 ===");
		
		List<ChampionVO> champions = lolDao.selectAllChampions(); 
		if (champions == null || champions.isEmpty()) return;

		// ✨ 멀티스레드 안전 카운터
		AtomicInteger successCount = new AtomicInteger(0);

		Pattern itemPattern = Pattern.compile("(?i)(?:item(?:/|%2F|id\"[:]|_id\"[:]))(\\d{4,})");
		Pattern runePattern = Pattern.compile("(?i)(?:perk|rune|talent)(?:/|%2F|id\"[:]|_id\"[:])(\\d{4,})");

		// ✨ OP.GG 차단을 막기 위해 스레드는 5개로 타협 (너무 많으면 403 Forbidden 뜸)
		ExecutorService executor = Executors.newFixedThreadPool(5);

		for (ChampionVO champ : champions) {
			executor.submit(() -> {
				String champEngId = champ.getId().toLowerCase(); 
				if (champEngId.equals("monkeyking")) champEngId = "wukong";
				
				String url = "https://www.op.gg/champions/" + champEngId + "/build";
				
				try {
					Document doc = Jsoup.connect(url)
							.userAgent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")
							.timeout(10000)
							.get();
					
					String htmlStr = doc.html();

					if (htmlStr.length() < 10000) { 
						System.out.println("🚨 [" + champ.getChampName() + "] 페이지 로딩 불충분");
						return; // 스레드 안에서는 continue 대신 return 사용
					}

					RecommendBuildVO buildVO = new RecommendBuildVO();
					buildVO.setChampNo(champ.getChampNo());

					Matcher itemMatcher = itemPattern.matcher(htmlStr);
					Set<Integer> itemSet = new java.util.LinkedHashSet<>();
					while (itemMatcher.find() && itemSet.size() < 3) {
						itemSet.add(Integer.parseInt(itemMatcher.group(1)));
					}
					
					Integer[] items = itemSet.toArray(new Integer[0]);
					if(items.length >= 1) buildVO.setItemNo1(items[0]);
					if(items.length >= 2) buildVO.setItemNo2(items[1]);
					if(items.length >= 3) buildVO.setItemNo3(items[2]);

					Matcher runeMatcher = runePattern.matcher(htmlStr);
					Set<Integer> runeSet = new java.util.LinkedHashSet<>();
					while (runeMatcher.find() && runeSet.size() < 4) {
						runeSet.add(Integer.parseInt(runeMatcher.group(1)));
					}

					Integer[] runes = runeSet.toArray(new Integer[0]);
					if(runes.length >= 1) buildVO.setTalentNo1(runes[0]);
					if(runes.length >= 2) buildVO.setTalentNo2(runes[1]);
					if(runes.length >= 3) buildVO.setTalentNo3(runes[2]);
					if(runes.length >= 4) buildVO.setTalentNo4(runes[3]);

					if(buildVO.getItemNo1() != null || buildVO.getTalentNo1() != null) {
						lolDao.replaceRecommendBuild(buildVO); 
						int currentSuccess = successCount.incrementAndGet();
						System.out.println("✅ [" + champ.getChampName() + "] OP.GG 매칭 완료 (" + currentSuccess + "/" + champions.size() + ")");
					}

				} catch (Exception e) {
					// 403이나 타임아웃 에러 발생 시 로그 출력
					System.out.println("❌ [" + champ.getChampName() + "] OP.GG 크롤링 오류: " + e.getMessage());
				}
			});
		}
		
		// 모든 크롤링 스레드가 종료될 때까지 대기
		executor.shutdown();
		try {
			executor.awaitTermination(15, TimeUnit.MINUTES);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		
		System.out.println("=== 추천 빌드 병렬 크롤링 완료 (총 " + successCount.get() + "명) ===");
	}
}