package com.semi.spring.battleground.model.service;

import java.util.Map;
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
            log.info(">>> PUBG 공식 아이템 데이터(itemId.json)를 다운로드합니다...");
            
            String jsonResponse;
            try {
                jsonResponse = restTemplate.getForObject(jsonUrl, String.class);
                log.info(">>> JSON 다운로드 성공! 데이터 길이: {}", jsonResponse.length());
            } catch (Exception e) {
                log.error(">>> JSON 파일을 읽어오는데 실패했습니다.", e);
                return; 
            }

            if (jsonResponse != null) {
                Map<String, String> itemData = objectMapper.readValue(jsonResponse, new TypeReference<Map<String, String>>() {});
                int count = 0;

                log.info(">>> 총 {}개의 데이터를 분석 시작합니다...", itemData.size());

                for (Map.Entry<String, String> entry : itemData.entrySet()) {
                    String itemKey = entry.getKey();     
                    String itemName = entry.getValue();  

                    if (itemName == null || itemName.trim().isEmpty() || itemKey.contains("Dummy")) {
                        continue;
                    }

                    BagItemInfoVO item = new BagItemInfoVO();
                    item.setItemName(itemName);
                    item.setItemInfo("공식 아이템 ID: " + itemKey); 

                    setCategoryInfo(item, itemKey);
                    
                    String imgUrl = generateImageUrl(itemKey);
                    item.setItemImg(imgUrl);

                    // ---------------------------------------------------------
                    // ✨ 강력한 디버깅용 DB 저장 로직 (에러 상세 출력)
                    // ---------------------------------------------------------
                    try {
                        bgDao.insertBagItem(item);
                        count++;
                    } catch (Exception e) {
                        // 에러가 발생하면 전체 스택 트레이스(원인)를 콘솔에 강제로 출력합니다.
                        log.error(">>> 💥 [DB 저장 실패] 아이템명: {}", itemName);
                        log.error(">>> 💥 실패 원인 상세: ", e); 
                    }
                }
                log.info("=== [배틀그라운드] 총 {}개의 아이템 (이름 + 이미지 URL) 저장 완료! ===", count);
            }
        } catch (Exception e) {
            log.error("=== [배틀그라운드] 전체 파싱 에러 ===", e);
        }
    }

    private void setCategoryInfo(BagItemInfoVO item, String itemKey) {
        int categoryNo = 5; 
        String itemType = "일반";
        String keyLower = itemKey.toLowerCase();
        
        if (keyLower.contains("weapon")) {
            categoryNo = 1; 
            itemType = "무기";
        } else if (keyLower.contains("attach") || keyLower.contains("scope") || keyLower.contains("muzzle") || keyLower.contains("grip")) {
            categoryNo = 2; 
            itemType = "부착물";
        } else if (keyLower.contains("ammo")) {
            categoryNo = 3; 
            itemType = "탄약";
        } else if (keyLower.contains("armor") || keyLower.contains("head") || keyLower.contains("vest")) {
            categoryNo = 4; 
            itemType = "방어구";
        } else if (keyLower.contains("heal") || keyLower.contains("boost") || keyLower.contains("energy") || keyLower.contains("painkiller")) {
            categoryNo = 5; 
            itemType = "회복/소모품";
        } else if (keyLower.contains("backpack")) {
            categoryNo = 5; 
            itemType = "가방";
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