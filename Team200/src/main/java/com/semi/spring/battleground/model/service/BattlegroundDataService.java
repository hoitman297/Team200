package com.semi.spring.battleground.model.service;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.annotation.PostConstruct;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.semi.spring.battleground.model.dao.BattlegroundDao;
import com.semi.spring.battleground.model.vo.BagItemInfoVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class BattlegroundDataService {

    private final BattlegroundDao bgDao;

    @PostConstruct
    public void init() {
        int count = bgDao.checkItemCount(); 
        
        if (count == 0) {
            log.info("=== [배틀그라운드] DB가 비어있어 공식 API Assets에서 아이템 데이터를 수집합니다 ===");
            new Thread(this::updateItemDataFromOfficial).start();
        } else {
            log.info("=== [배틀그라운드] 이미 아이템 데이터가 존재합니다. ===");
        }
    }

    public void updateItemDataFromOfficial() {
        try {
            RestTemplate restTemplate = new RestTemplate();
            ObjectMapper objectMapper = new ObjectMapper(); 

            String jsonUrl = "https://raw.githubusercontent.com/pubg/api-assets/master/dictionaries/telemetry/item/itemId.json";
            log.info(">>> PUBG 공식 아이템 데이터 다운로드 중...");
            
            String jsonResponse = restTemplate.getForObject(jsonUrl, String.class);

            if (jsonResponse != null) {
                Map<String, String> itemData = objectMapper.readValue(jsonResponse, new TypeReference<Map<String, String>>() {});
                int count = 0;
                
                // ⭐ [핵심 추가] 중복 아이템 이름을 추적하기 위한 Set 객체 생성
                Set<String> seenItemNames = new HashSet<>();

                log.info(">>> 총 {}개의 원본 데이터 분석 시작...", itemData.size());

                for (Map.Entry<String, String> entry : itemData.entrySet()) {
                    String itemKey = entry.getKey();     
                    String itemName = entry.getValue();  

                    // 1. 유효성 검사 (빈 값, 더미 데이터 제외)
                    if (itemName == null || itemName.trim().isEmpty() || itemKey.contains("Dummy")) {
                        continue;
                    }

                    // ⭐ 2. [핵심 추가] 이미 저장된 아이템 이름이면 건너뛰기 (중복 방지)
                    if (seenItemNames.contains(itemName)) {
                        continue; 
                    }

                    // 3. 중복이 아니면 Set에 기록해두기
                    seenItemNames.add(itemName);

                    BagItemInfoVO item = new BagItemInfoVO();
                    item.setItemName(itemName);
                    item.setItemInfo("공식 아이템 ID: " + itemKey); 

                    // 카테고리 판별 (앞서 수정한 부착물 우선순위 로직 적용)
                    setCategoryInfo(item, itemKey);
                    
                    // 이미지 URL 생성
                    String imgUrl = generateImageUrl(itemKey);
                    item.setItemImg(imgUrl);

                    // DB 저장
                    try {
                        bgDao.insertBagItem(item);
                        count++;
                    } catch (Exception e) {
                        log.error(">>> 💥 [DB 저장 실패] 아이템명: {}", itemName);
                    }
                }
                log.info("=== [배틀그라운드] 중복 제거 후 총 {}개의 아이템 저장 완료! ===", count);
            }
        } catch (Exception e) {
            log.error("=== [배틀그라운드] 전체 파싱 에러 ===", e);
        }
    }
    
    private void setCategoryInfo(BagItemInfoVO item, String itemKey) {
        int categoryNo = 5; // 기본값
        String itemType = "기타/소모품";
        String keyLower = itemKey.toLowerCase();
        
        // 1. 부착물(Attach)을 무기(Weapon)보다 먼저 체크합니다. (우선순위 상향)
        // 이유: 파츠 아이템 ID에 'weapon'이 포함된 경우가 많음 (예: Item_Attach_Weapon_Muzzle...)
        if (keyLower.contains("attach") || keyLower.contains("scope") || 
            keyLower.contains("muzzle") || keyLower.contains("grip") || 
            keyLower.contains("stock") || keyLower.contains("magazine")) {
            categoryNo = 2; 
            itemType = "부착물";
        } 
        // 2. 부착물이 아닌 것 중 'weapon'이 포함된 것을 순수 무기로 분류
        else if (keyLower.contains("weapon")) {
            categoryNo = 1; 
            itemType = "무기";
        } 
        // 3. 탄약
        else if (keyLower.contains("ammo")) {
            categoryNo = 3; 
            itemType = "탄약";
        } 
        // 4. 방어구 및 가방 (헬멧, 조끼, 가방 등)
        else if (keyLower.contains("armor") || keyLower.contains("head") || 
                 keyLower.contains("vest") || keyLower.contains("helmet") || 
                 keyLower.contains("backpack") || keyLower.contains("equip")) {
            categoryNo = 4; 
            itemType = "방어구";
        } 
        // 5. 회복 및 부스트 아이템
        else if (keyLower.contains("heal") || keyLower.contains("boost") || 
                 keyLower.contains("energy") || keyLower.contains("painkiller") || 
                 keyLower.contains("firstaid") || keyLower.contains("medkit")) {
            categoryNo = 5; 
            itemType = "회복/소모품";
        }

        item.setCategoryNo(categoryNo);
        item.setItemType(itemType);
    }

    private String generateImageUrl(String itemKey) {
        String imageBaseUrl = "https://raw.githubusercontent.com/pubg/api-assets/master/Assets/Item/";
        String folderPath = "";
        String keyLower = itemKey.toLowerCase();

        if (keyLower.contains("weapon")) {
            folderPath = "Weapon/"; 
        } else if (keyLower.contains("attach")) {
            folderPath = "Weapon/Attachment/"; 
        } else if (keyLower.contains("ammo")) {
            folderPath = "Ammo/"; 
        } else if (keyLower.contains("armor") || keyLower.contains("head") || keyLower.contains("equip")) {
            folderPath = "Equipment/"; 
        } else if (keyLower.contains("boost")) {
            folderPath = "Use/Boost/"; 
        } else if (keyLower.contains("heal")) {
            folderPath = "Use/Heal/"; 
        } else {
            folderPath = "Etc/"; 
        }
        
        return imageBaseUrl + folderPath + itemKey + ".png";
    }
}