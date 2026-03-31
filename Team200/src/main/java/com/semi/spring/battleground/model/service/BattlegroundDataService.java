package com.semi.spring.battleground.model.service;

import java.util.Map;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

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
        // 서버 시작 시 DB에 아이템이 있는지 확인
        int count = bgDao.checkItemCount(); 
        
        if (count == 0) {
            log.info("=== [배틀그라운드] DB가 비어있어 공식 API Assets에서 아이템 데이터를 수집합니다 ===");
            new Thread(() -> updateItemDataFromOfficial()).start();
        } else {
            log.info("=== [배틀그라운드] 이미 아이템 데이터가 존재합니다. ===");
        }
    }

    public void updateItemDataFromOfficial() {
        try {
            RestTemplate restTemplate = new RestTemplate();

            // PUBG 공식 API에서 제공하는 아이템 사전(Dictionary) JSON URL
            String officialItemUrl = "https://raw.githubusercontent.com/pubg/api-assets/master/dictionaries/telemetry/item.json";
            
            log.info(">>> PUBG 공식 아이템 데이터(JSON)를 다운로드합니다...");
            
            // JSON 데이터가 "키":"값" 형태이므로 Map으로 바로 받아옵니다.
            Map<String, String> itemData = restTemplate.getForObject(officialItemUrl, Map.class);

            if (itemData != null) {
                int count = 0;

                for (Map.Entry<String, String> entry : itemData.entrySet()) {
                    String itemKey = entry.getKey();     // 예: "Item_Weapon_AK47_C"
                    String itemName = entry.getValue();  // 예: "AKM"

                    // 불필요한 시스템 더미 데이터나 이름이 없는 데이터는 패스
                    if (itemName == null || itemName.trim().isEmpty() || itemKey.contains("Dummy")) {
                        continue;
                    }

                    BagItemInfoVO item = new BagItemInfoVO();
                    item.setItemName(itemName);
                    
                    // 공식 JSON에는 상세 설명이 없으므로, 기본 설명으로 아이템 ID(Key)를 넣어두거나 임의 처리합니다.
                    item.setItemInfo("공식 분류 ID: " + itemKey); 

                    // ---------------------------------------------------------
                    // [핵심] 키(Key) 값을 분석하여 카테고리(1~5)와 타입 자동 분류
                    // ---------------------------------------------------------
                    int categoryNo = 5; // 기본값: 소모품(기타)
                    String itemType = "일반";

                    String keyLower = itemKey.toLowerCase();
                    
                    if (keyLower.contains("weapon")) {
                        categoryNo = 1; // 무기
                        itemType = "무기";
                    } else if (keyLower.contains("attach") || keyLower.contains("scope") || keyLower.contains("muzzle")) {
                        categoryNo = 2; // 부착물
                        itemType = "부착물";
                    } else if (keyLower.contains("ammo")) {
                        categoryNo = 3; // 탄약
                        itemType = "탄약";
                    } else if (keyLower.contains("armor") || keyLower.contains("head")) {
                        categoryNo = 4; // 방어구 (조끼, 헬멧)
                        itemType = "방어구";
                    } else if (keyLower.contains("heal") || keyLower.contains("boost") || keyLower.contains("energy")) {
                        categoryNo = 5; // 소모품 (회복/부스트)
                        itemType = "회복/소모품";
                    } else if (keyLower.contains("backpack")) {
                        categoryNo = 5; 
                        itemType = "가방";
                    }
                    
                    item.setCategoryNo(categoryNo);
                    item.setItemType(itemType);

                    // ---------------------------------------------------------
                    // 이미지 처리 (공식 아이콘 URL 조립)
                    // ---------------------------------------------------------
                    // 공식 Assets 저장소의 규칙을 사용하여 이미지 URL을 유추할 수 있습니다.
                    // (단, 모든 아이템 이미지가 완벽하게 일치하지는 않을 수 있어 예외 처리가 필요할 수 있습니다)
                    String imgUrl = "https://raw.githubusercontent.com/pubg/api-assets/master/assets/icons/item/" + itemKey + ".png";
                    item.setItemImg(imgUrl);

                    try {
                        bgDao.insertBagItem(item);
                        count++;
                    } catch (Exception e) {
                        log.error(">>> [{}] 아이템 DB 저장 실패: {}", itemName, e.getMessage());
                    }
                }
                log.info("=== [배틀그라운드] 공식 데이터 기반 총 {}개의 아이템 정보 저장 완료! ===", count);
            }
        } catch (Exception e) {
            log.error("=== [배틀그라운드] 공식 API 데이터 파싱 중 에러 발생 ===", e);
        }
    }
}