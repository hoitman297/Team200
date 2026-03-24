package com.semi.spring.lol.model.service;


import java.util.List;
import java.util.Map;

import java.util.HashSet;
import java.util.Set;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.semi.spring.lol.model.dao.LolDao;
import com.semi.spring.lol.model.vo.ChampionVO;
import com.semi.spring.lol.model.vo.LolItemVO;
import com.semi.spring.lol.model.vo.SkillVO;
import com.semi.spring.lol.model.vo.SkinVO;

@Service
public class LolDataService {

    @Autowired
    private LolDao lolDao;
    
    // =========================================================================
    // [수정됨] 이미지 확인 도우미 메서드 (기다리는 시간을 1초로 단축!)
    // =========================================================================
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
        List<ChampionVO> list = lolDao.selectAllChampions();
        if(list == null || list.isEmpty()) {
            System.out.println("=== DB가 비어있어 API 데이터를 가져옵니다 ===");

            new Thread(() -> updateChampionData()).start(); 
            
        } else {
            System.out.println("=== 이미 " + list.size() + "개의 데이터가 있어 업데이트를 건너뜁니다. ===");
        }
        
        List<LolItemVO> itemList = lolDao.selectAllItems();
        if(itemList == null || itemList.isEmpty()) {
            System.out.println("=== 아이템 DB가 비어있어 API 데이터를 가져옵니다 ===");
            new Thread(() -> updateItemData()).start();
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
                skillVO.setSkillQImg(baseUrl + "/img/spell/" + ((Map<String, Object>)spells.get(0).get("image")).get("full"));
                
                skillVO.setSkillWName((String) spells.get(1).get("name"));
                skillVO.setSkillWDesc((String) spells.get(1).get("description"));
                skillVO.setSkillWImg(baseUrl + "/img/spell/" + ((Map<String, Object>)spells.get(1).get("image")).get("full"));
                
                skillVO.setSkillEName((String) spells.get(2).get("name"));
                skillVO.setSkillEDesc((String) spells.get(2).get("description"));
                skillVO.setSkillEImg(baseUrl + "/img/spell/" + ((Map<String, Object>)spells.get(2).get("image")).get("full"));
                
                skillVO.setSkillRName((String) spells.get(3).get("name"));
                skillVO.setSkillRDesc((String) spells.get(3).get("description"));
                skillVO.setSkillRImg(baseUrl + "/img/spell/" + ((Map<String, Object>)spells.get(3).get("image")).get("full"));

                lolDao.insertChampionSkills(skillVO);

                // =========================================================
                // [핵심 변경] 2-2. 스킨 파싱 및 저장 (병렬 스트림 사용)
                // =========================================================
                List<Map<String, Object>> skins = (List<Map<String, Object>>) detail.get("skins");
                
                // for문 대신 parallelStream()을 사용하여 여러 스킨을 동시에 처리합니다!
                skins.parallelStream().forEach(skinData -> {
                    SkinVO skinVO = new SkinVO();
                    skinVO.setChampNo(currentChampNo);
                    
                    String skinName = (String) skinData.get("name");
                    if ("default".equalsIgnoreCase(skinName)) {
                        skinName = "기본"; 
                    }
                    skinVO.setChampSkinName(skinName);
                    
                    String skinNum = String.valueOf(skinData.get("num"));
                    String skinImgUrl = "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/" + key + "_" + skinNum + ".jpg";
                    
                    if (!isImageUrlValid(skinImgUrl)) {
                        System.out.println("[" + champ.getChampName() + " - " + skinName + "] 이미지가 없습니다. 저장을 생략합니다.");
                        return; // 람다식 내부에서는 continue 대신 return
                    }
                    
                    skinVO.setChampSkinImg(skinImgUrl);
                    lolDao.insertChampionSkin(skinVO);
                });
                // =========================================================

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
                
                if (!itemInfo.containsKey("name")) continue;
                
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
                
                if (!purchasable) continue; 
                if (totalPrice == 0 && !isWard) continue; 
                
                if (processedNames.contains(itemName)) continue;
                
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
                    if(desc != null) {
                        desc = desc.replaceAll("<[^>]*>", " "); 
                        if(desc.length() > 300) desc = desc.substring(0, 300) + "...";
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
}