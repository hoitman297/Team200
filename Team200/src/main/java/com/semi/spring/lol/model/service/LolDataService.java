package com.semi.spring.lol.model.service;

import java.net.URLDecoder;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher; // ✨ 추가됨
import java.util.regex.Pattern; // ✨ 추가됨

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
	public void init() {
		// 1. 챔피언 데이터 체크
		List<ChampionVO> list = lolDao.selectAllChampions();
		if (list == null || list.isEmpty()) {
			System.out.println("=== 롤 챔피언 DB가 비어있어 API 데이터를 가져옵니다 ===");

			new Thread(() -> {
				// 챔피언 데이터를 먼저 가져오고
				updateChampionData(); 
				
				// ✨ 챔피언 저장이 끝난 후 안전하게 추천 빌드 크롤링 시작
				System.out.println("=== 챔피언 데이터 저장이 완료되어 추천 빌드 크롤링을 시작합니다 ===");
				updateRecommendedBuilds(); 
			}).start();

		} else {
			System.out.println("=== 이미 " + list.size() + "개의 데이터가 있어 챔피언 업데이트를 건너뜁니다. ===");
			
			// ✨ 이미 챔피언 데이터가 있다면 바로 추천 빌드 크롤링 시작
			// (주의: 서버를 켤 때마다 전체 크롤링이 돌면 시간이 꽤 걸리므로, 나중에는 크롤링 주기나 데이터 존재 여부를 체크하는 로직을 넣는 것도 좋아!)
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

			int insertCount = 0;
			for (String key : data.keySet()) {
				// [1단계] 챔피언 기본 정보
				Map<String, Object> champInfo = (Map<String, Object>) data.get(key);
				ChampionVO champ = new ChampionVO();
				champ.setChampName((String) champInfo.get("name"));

				List<String> tags = (List<String>) champInfo.get("tags");
				champ.setChampPosition(String.join(", ", tags));

				// =========================================================
				// ✨ [추가된 부분] 챔피언 소개글(blurb) 파싱 및 저장
				// =========================================================
				String intro = (String) champInfo.get("blurb");
				if (intro != null) {
					// 텍스트에 <b>, <br> 등의 HTML 태그가 섞여 있을 수 있으므로 정규식으로 깔끔하게 제거합니다.
					champ.setChampIntro(intro.replaceAll("<[^>]*>", "").trim());
				} else {
					champ.setChampIntro("소개글이 없습니다.");
				}
				// =========================================================

				String imgUrl = baseUrl + "/img/champion/" + key + ".png";
				champ.setChampImg(imgUrl);

				lolDao.insertChampion(champ);
				int currentChampNo = champ.getChampNo();

				// [2단계] 챔피언 상세 정보
				String detailUrl = baseUrl + "/data/ko_KR/champion/" + key + ".json";
				Map<String, Object> detailRes = restTemplate.getForObject(detailUrl, Map.class);
				Map<String, Object> detailData = (Map<String, Object>) detailRes.get("data");
				Map<String, Object> detail = (Map<String, Object>) detailData.get(key);

				// --- 2-1. 스킬 파싱 및 저장 ---
				SkillVO skillVO = new SkillVO();
				skillVO.setChampNo(currentChampNo);

				Map<String, Object> passive = (Map<String, Object>) detail.get("passive");
				skillVO.setSkillPName((String) passive.get("name"));
				skillVO.setSkillPDesc((String) passive.get("description"));
				Map<String, Object> passiveImgObj = (Map<String, Object>) passive.get("image");
				skillVO.setSkillPImg(baseUrl + "/img/passive/" + passiveImgObj.get("full"));

				List<Map<String, Object>> spells = (List<Map<String, Object>>) detail.get("spells");

				skillVO.setSkillQName((String) spells.get(0).get("name"));
				skillVO.setSkillQDesc((String) spells.get(0).get("description"));
				skillVO.setSkillQImg(
						baseUrl + "/img/spell/" + ((Map<String, Object>) spells.get(0).get("image")).get("full"));

				skillVO.setSkillWName((String) spells.get(1).get("name"));
				skillVO.setSkillWDesc((String) spells.get(1).get("description"));
				skillVO.setSkillWImg(
						baseUrl + "/img/spell/" + ((Map<String, Object>) spells.get(1).get("image")).get("full"));

				skillVO.setSkillEName((String) spells.get(2).get("name"));
				skillVO.setSkillEDesc((String) spells.get(2).get("description"));
				skillVO.setSkillEImg(
						baseUrl + "/img/spell/" + ((Map<String, Object>) spells.get(2).get("image")).get("full"));

				skillVO.setSkillRName((String) spells.get(3).get("name"));
				skillVO.setSkillRDesc((String) spells.get(3).get("description"));
				skillVO.setSkillRImg(
						baseUrl + "/img/spell/" + ((Map<String, Object>) spells.get(3).get("image")).get("full"));

				lolDao.insertChampionSkills(skillVO);

				// --- 2-2. 스킨 파싱 및 저장 (병렬 스트림) ---
				List<Map<String, Object>> skins = (List<Map<String, Object>>) detail.get("skins");

				skins.parallelStream().forEach(skinData -> {
					SkinVO skinVO = new SkinVO();
					skinVO.setChampNo(currentChampNo);

					String skinName = (String) skinData.get("name");
					if ("default".equalsIgnoreCase(skinName)) {
						skinName = "기본";
					}
					skinVO.setChampSkinName(skinName);

					String skinNum = String.valueOf(skinData.get("num"));
					String skinImgUrl = "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/" + key + "_"
							+ skinNum + ".jpg";

					if (!isImageUrlValid(skinImgUrl)) {
						return;
					}

					skinVO.setChampSkinImg(skinImgUrl);
					lolDao.insertChampionSkin(skinVO);
				});

				insertCount++;
			}
			System.out.println("=== [성공] 총 " + insertCount + "명의 챔피언과 스킬/스킨을 DB에 저장했습니다! ===");
		} catch (Exception e) {
			System.out.println("=== [에러 발생] 데이터 업데이트 중지: " + e.getMessage());
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
				Map<String, Object> itemInfo = (Map<String, Object>) data.get(key);

				if (!itemInfo.containsKey("name"))
					continue;

				// =========================================================
				// [추가된 필터링] 맵 정보 확인 (소환사의 협곡 아이템만 가져오기)
				// =========================================================
				Map<String, Boolean> maps = (Map<String, Boolean>) itemInfo.get("maps");
				// "11"은 소환사의 협곡 ID입니다. 이 값이 없거나 false라면 소환사의 협곡용이 아니므로 패스!
				if (maps == null || maps.get("11") == null || maps.get("11") == false) {
					continue;
				}
				// =========================================================

				String itemName = (String) itemInfo.get("name");

				Map<String, Object> goldInfo = (Map<String, Object>) itemInfo.get("gold");
				boolean purchasable = (boolean) goldInfo.get("purchasable");
				int totalPrice = (Integer) goldInfo.get("total");

				List<String> tags = (List<String>) itemInfo.get("tags");
				boolean isWard = tags != null && (tags.contains("Trinket") || tags.contains("Vision"));

				if (!purchasable)
					continue;
				if (totalPrice == 0 && !isWard)
					continue;

				if (processedNames.contains(itemName))
					continue;

				processedNames.add(itemName);

				LolItemVO itemVO = new LolItemVO();
				itemVO.setItemNo(Integer.parseInt(key));
				itemVO.setItemName(itemName);
				itemVO.setItemPrice(totalPrice);

				String plaintext = (String) itemInfo.get("plaintext");
				if (plaintext != null && !plaintext.trim().isEmpty()) {
					itemVO.setItemInfo(plaintext);
				} else {
					String desc = (String) itemInfo.get("description");
					if (desc != null) {
						desc = desc.replaceAll("<[^>]*>", " ");
						if (desc.length() > 300)
							desc = desc.substring(0, 300) + "...";
						itemVO.setItemInfo(desc.trim());
					}
				}

				String imgUrl = baseUrl + "/img/item/" + key + ".png";
				itemVO.setItemImg(imgUrl);

				if (tags != null) {
					itemVO.setItemTag(String.join(",", tags));
				} else {
					itemVO.setItemTag("");
				}

				lolDao.insertItem(itemVO);
				insertCount++;
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

			// 최신 버전 가져오기
			String versionUrl = "https://ddragon.leagueoflegends.com/api/versions.json";
			List<String> versions = restTemplate.getForObject(versionUrl, List.class);
			String latestVersion = versions.get(0);

			// 룬 정보 API URL (한국어 데이터)
			String runeUrl = "https://ddragon.leagueoflegends.com/cdn/" + latestVersion
					+ "/data/ko_KR/runesReforged.json";

			// API 호출 (List<Map> 구조로 받음)
			List<Map<String, Object>> runeDataList = restTemplate.getForObject(runeUrl, List.class);

			int runeCount = 0;
			int talentCount = 0;

			for (Map<String, Object> pathMap : runeDataList) {
				// [1단계] RUNE_INFO 저장 (정밀, 지배 등 핵심 빌드)
				RuneVO rune = new RuneVO();
				rune.setRuneName((String) pathMap.get("name"));
				rune.setRuneInfo((String) pathMap.get("key")); // 영문명(Precision 등) 저장
				// 아이콘 경로는 다른 API와 달리 'img/' 바로 뒤에 붙음
				rune.setRuneImg("https://ddragon.leagueoflegends.com/cdn/img/" + pathMap.get("icon"));

				// insertRune 실행 (MyBatis에서 SEQ_RUNE_NO.NEXTVAL 사용)
				lolDao.insertRune(rune);
				int generatedRuneNo = rune.getRuneNo(); // selectKey를 통해 받아온 PK
				runeCount++;

				// [2단계] TALENT_INFO 저장 (해당 빌드에 속한 모든 개별 룬)
				List<Map<String, Object>> slots = (List<Map<String, Object>>) pathMap.get("slots");

				for (Map<String, Object> slot : slots) {
					List<Map<String, Object>> runesInSlot = (List<Map<String, Object>>) slot.get("runes");

					for (Map<String, Object> rObj : runesInSlot) {
						TalentVO talent = new TalentVO();
						talent.setRuneNo(generatedRuneNo); // FK 설정
						talent.setTalentName((String) rObj.get("name"));

						// HTML 태그 제거 및 길이 제한 처리
						String rawDesc = (String) rObj.get("shortDesc");
						if (rawDesc != null) {
							rawDesc = rawDesc.replaceAll("<[^>]*>", ""); // <b> 등 태그 제거
							if (rawDesc.length() > 300)
								rawDesc = rawDesc.substring(0, 300);
						}
						talent.setTalentInfo(rawDesc);
						talent.setTalentImg("https://ddragon.leagueoflegends.com/cdn/img/" + rObj.get("icon"));

						lolDao.insertTalent(talent);
						talentCount++;
					}
				}
			}
			System.out.println("=== [성공] " + runeCount + "개의 빌드와 " + talentCount + "개의 특성 저장 완료! ===");

		} catch (Exception e) {
			System.err.println("=== [에러] 룬 데이터 수집 중 오류 발생 ===");
			e.printStackTrace();
		}
	}


	    public void updateRecommendedBuilds() {
	        System.out.println("=== 추천 빌드 데이터(ID 기반 최적화) 크롤링 시작 ===");
	        
	        List<ChampionVO> champions = lolDao.selectAllChampions(); 
	        if (champions == null || champions.isEmpty()) return;

	        int successCount = 0;

	        // ✨ 최신 OP.GG JSON/HTML 구조 대응 패턴
	        // 아이템: item/3153 또는 "item_id":3153 등 대응
	        Pattern itemPattern = Pattern.compile("(?i)(?:item(?:/|%2F|id\"[:]|_id\"[:]))(\\d{4,})");
	        // 룬/특성: perk/8005 또는 "perk_id":8005 등 대응
	        Pattern runePattern = Pattern.compile("(?i)(?:perk|rune|talent)(?:/|%2F|id\"[:]|_id\"[:])(\\d{4,})");

	        for (ChampionVO champ : champions) {
	            // DB의 ID가 대문자일 수 있으므로 변환 (가렌 -> Garen -> garen)
	            // ChampionVO에 getId()가 없다면 getName() 등을 활용해 영어 ID를 매칭해야 합니다.
	            String champEngId = champ.getId().toLowerCase(); 
	            if (champEngId.equals("monkeyking")) champEngId = "wukong";
	            
	            String url = "https://www.op.gg/champions/" + champEngId + "/build";
	            
	            try {
	                Document doc = Jsoup.connect(url)
	                        .userAgent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")
	                        .timeout(10000)
	                        .get();
	                
	                String htmlStr = doc.html();

	                if (htmlStr.length() < 10000) { // 페이지가 너무 작으면 로딩 실패나 차단
	                    System.out.println("🚨 [" + champ.getChampName() + "] 페이지 로딩 불충분");
	                    continue;
	                }

	                RecommendBuildVO buildVO = new RecommendBuildVO();
	                buildVO.setChampNo(champ.getChampNo());

	                // [1] 아이템 번호(ID) 추출 - 중복 제거를 위해 Set 사용 권장
	                Matcher itemMatcher = itemPattern.matcher(htmlStr);
	                Set<Integer> itemSet = new java.util.LinkedHashSet<>();
	                while (itemMatcher.find() && itemSet.size() < 3) {
	                    itemSet.add(Integer.parseInt(itemMatcher.group(1)));
	                }
	                
	                Integer[] items = itemSet.toArray(new Integer[0]);
	                if(items.length >= 1) buildVO.setItemNo1(items[0]);
	                if(items.length >= 2) buildVO.setItemNo2(items[1]);
	                if(items.length >= 3) buildVO.setItemNo3(items[2]);

	                // [2] 룬 번호(ID) 추출
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

	                // [3] DB 저장 (Upsert 로직 추천)
	                if(buildVO.getItemNo1() != null || buildVO.getTalentNo1() != null) {
	                    // ✨ 기존 데이터가 있는지 확인 후 처리하는 Dao 메서드를 호출하세요.
	                    // 또는 MyBatis의 MERGE INTO 구문을 사용하면 더 깔끔합니다.
	                    lolDao.replaceRecommendBuild(buildVO); 
	                    successCount++;
	                    System.out.println("✅ [" + champ.getChampName() + "] ID 매칭 완료 (아이템1:" + buildVO.getItemNo1() + ")");
	                }

	                Thread.sleep(1500); // OP.GG 예의 지키기

	            } catch (Exception e) {
	                System.out.println("❌ [" + champ.getChampName() + "] 오류: " + e.getMessage());
	            }
	        }
	        System.out.println("=== 추천 빌드 크롤링 완료 (총 " + successCount + "명) ===");
	    }
}