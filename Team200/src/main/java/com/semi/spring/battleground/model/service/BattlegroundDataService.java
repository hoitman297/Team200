package com.semi.spring.battleground.model.service;

import java.net.HttpURLConnection;
import java.net.URL;
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

    private final BattlegroundDao dao;

    @PostConstruct
    public void init() {
        int count = dao.checkItemCount(); 
        
        if (count == 0) {
            log.info("=== [배틀그라운드] DB가 비어있어 공식 API Assets에서 아이템 데이터를 수집합니다 ===");
            
            Thread dataUpdateThread = new Thread(this::updateItemDataFromOfficial);
            dataUpdateThread.setDaemon(true);
            dataUpdateThread.start();
            
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
                int skipCount = 0; 
                
                Set<String> seenItemNames = new HashSet<>();

                log.info(">>> 총 {}개의 원본 데이터 분석 시작...", itemData.size());

                for (Map.Entry<String, String> entry : itemData.entrySet()) {
                    String itemKey = entry.getKey();     
                    String originalName = entry.getValue();  

                    // Dummy 데이터 및 블루존 수류탄 스킵 처리
                    if (originalName == null || originalName.trim().isEmpty() || 
                        itemKey.contains("Dummy") || itemKey.toLowerCase().contains("bluezone")) {
                        continue;
                    }

                    // 한글 이름으로 변환
                    String koreanName = translateToKorean(itemKey, originalName);

                    // 한글 이름 기준으로 중복 제거
                    if (seenItemNames.contains(koreanName)) {
                        continue; 
                    }

                    String imgUrl = generateImageUrl(itemKey);
                    
                    if (imgUrl == null || imgUrl.isEmpty() || !isValidImageUrl(imgUrl)) {
                        log.debug(">>> [저장 스킵] 이미지 없음: {} ({})", koreanName, imgUrl);
                        skipCount++;
                        continue; 
                    }

                    seenItemNames.add(koreanName);

                    BagItemInfoVO item = new BagItemInfoVO();
                    item.setItemName(koreanName); 
                    item.setItemInfo("공식 ID: " + itemKey); 
                    item.setItemImg(imgUrl);

                    setCategoryInfo(item, itemKey);

                    try {
                        dao.insertBagItem(item);
                        count++;
                    } catch (Exception e) {
                        log.error(">>> [DB 저장 실패] 아이템명: {}", koreanName);
                    }
                }
                log.info("=== [배틀그라운드] 아이템 저장 완료! (저장됨: {}, 스킵됨(이미지없음): {}) ===", count, skipCount);
            }
        } catch (Exception e) {
            log.error("=== [배틀그라운드] 전체 파싱 에러 ===", e);
        }
    }
    
    // ⭐ 아이템 키와 영문 원본 이름을 모두 분석하여 한국어 이름으로 맵핑하는 메서드
    private String translateToKorean(String itemKey, String originalName) {
        String keyLower = itemKey.toLowerCase();
        String origLower = originalName.toLowerCase();
        
        // 1. 투척무기 (수류탄을 정확한 코드로만 매핑)
        if (keyLower.contains("snowball")) return "눈덩이";
        //Item_Weapon_Grenade_C 만 수류탄으로 취급
        if (keyLower.equals("item_weapon_grenade_c")) return "수류탄"; 
        
        if (keyLower.contains("decoy") || origLower.contains("decoy")) return "교란 수류탄";
        if (keyLower.contains("rock") || origLower.equals("rock")) return "돌멩이";
        
        if (keyLower.contains("smoke")) return "연막탄";
        if (keyLower.contains("flashbang")) return "섬광탄";
        if (keyLower.contains("molotov")) return "화염병";
        if (keyLower.contains("sticky")) return "점착 폭탄";
        if (keyLower.contains("c4")) return "C4";
        if (keyLower.contains("apple")) return "사과";
        if (keyLower.contains("spiketrap")) return "스파이크 트랩";
        
        // 2. 회복 및 소모품
        if (keyLower.contains("energy")) return "에너지 드링크";
        if (keyLower.contains("painkiller")) return "진통제";
        if (keyLower.contains("adrenaline")) return "아드레날린 주사기";
        if (keyLower.contains("bandage")) return "붕대";
        if (keyLower.contains("firstaid")) return "구급상자";
        if (keyLower.contains("medkit")) return "의료용 키트";
        if (keyLower.contains("gascan") || keyLower.contains("jerrycan")) return "연료통";
        
        // 3. 방어구 및 배낭
        if (origLower.contains("spetsnaz") || (keyLower.contains("head") && keyLower.contains("lv3"))) return "헬멧 (Lv.3)";
        if (origLower.contains("military helmet") || (keyLower.contains("head") && keyLower.contains("lv2"))) return "헬멧 (Lv.2)";
        if (origLower.contains("motorcycle helmet") || (keyLower.contains("head") && keyLower.contains("lv1"))) return "헬멧 (Lv.1)";
        if (keyLower.contains("helmet")) {
            if (keyLower.contains("lv1")) return "헬멧 (Lv.1)";
            if (keyLower.contains("lv2")) return "헬멧 (Lv.2)";
            if (keyLower.contains("lv3")) return "헬멧 (Lv.3)";
            return "헬멧";
        }
        if (keyLower.contains("vest") || keyLower.contains("armor")) {
            if (keyLower.contains("lv1")) return "경찰 조끼 (Lv.1)";
            if (keyLower.contains("lv2")) return "경찰 조끼 (Lv.2)";
            if (keyLower.contains("lv3")) return "군용 조끼 (Lv.3)";
            return "방탄 조끼";
        }
        if (keyLower.contains("backpack") || keyLower.contains("back_")) {
            if (keyLower.contains("lv1")) return "배낭 (Lv.1)";
            if (keyLower.contains("lv2")) return "배낭 (Lv.2)";
            if (keyLower.contains("lv3")) return "배낭 (Lv.3)";
            return "배낭";
        }
        if (keyLower.contains("ghillie")) return "길리 슈트";
        if (keyLower.contains("parachute")) return "낙하산";

        // 4. 탄약
        if (keyLower.contains("ammo")) {
            if (keyLower.contains("556mm")) return "5.56mm 탄약";
            if (keyLower.contains("762mm")) return "7.62mm 탄약";
            if (keyLower.contains("9mm")) return "9mm 탄약";
            if (keyLower.contains("45acp")) return ".45 ACP 탄약";
            if (keyLower.contains("12guage") || keyLower.contains("12gauge")) return "12 게이지";
            if (keyLower.contains("300magnum")) return ".300 매그넘";
            if (keyLower.contains("57mm")) return "57mm 탄약";
            if (keyLower.contains("40mm")) return "40mm 탄약";
            return "탄약";
        }

        // 5. 부착물
        if (origLower.contains("15x") || keyLower.contains("15x") || keyLower.contains("pm2")) return "15배율 스코프";
        if (origLower.contains("8x") || keyLower.contains("8x") || keyLower.contains("cqbss")) return "8배율 스코프";
        if (origLower.contains("6x") || keyLower.contains("6x")) return "6배율 스코프";
        if (origLower.contains("4x") || keyLower.contains("4x") || keyLower.contains("acog")) return "4배율 스코프";
        if (origLower.contains("3x") || keyLower.contains("3x")) return "3배율 스코프";
        if (origLower.contains("2x") || keyLower.contains("2x") || keyLower.contains("aimpoint")) return "2배율 스코프";
        if (origLower.contains("red dot") || origLower.contains("reddot") || keyLower.contains("reddot") || keyLower.contains("dotsight")) return "레드 도트 사이트";
        if (origLower.contains("holographic") || origLower.contains("holo") || keyLower.contains("holosight")) return "홀로그램 조준경";

        if (origLower.contains("vertical foregrip") || (keyLower.contains("lower") && keyLower.contains("foregrip") && !keyLower.contains("angled") && !keyLower.contains("lightweight") && !keyLower.contains("half"))) return "수직 손잡이";
        if (origLower.contains("angled") || keyLower.contains("angled")) return "앵글 손잡이";
        if (origLower.contains("half grip") || keyLower.contains("half")) return "하프 그립";
        if (origLower.contains("lightweight") || keyLower.contains("lightweight")) return "라이트 그립";
        if (origLower.contains("thumb grip") || keyLower.contains("thumb")) return "엄지 그립";
        if (origLower.contains("laser pointer") || keyLower.contains("laser")) return "레이저 포인트";

        if (origLower.contains("tactical stock") || keyLower.contains("ar_composite")) return "전술 개머리판";
        if (origLower.contains("uzi stock") || keyLower.contains("stock_uzi")) return "UZI 개머리판";
        if (origLower.contains("quiver") || keyLower.contains("quiver")) return "화살통 (석궁)";
        if (origLower.contains("cheek pad") || keyLower.contains("cheekpad")) return "칙패드";
        if (origLower.contains("bullet loop") || keyLower.contains("bulletloops")) return "탄띠";
        if (origLower.contains("heavy stock") || (keyLower.contains("stock") && keyLower.contains("heavy"))) return "중량 개머리판";

        if (origLower.contains("compensator") || keyLower.contains("compensator")) return "보정기";
        if (origLower.contains("flash hider") || keyLower.contains("flashhider")) return "소염기";
        if (origLower.contains("suppressor") || keyLower.contains("suppressor")) return "소음기";
        if (origLower.contains("choke") || keyLower.contains("choke")) return "초크";
        if (origLower.contains("duckbill") || keyLower.contains("duckbill")) return "덕빌";

        if (origLower.contains("extended quickdraw") || keyLower.contains("extendedquickdraw")) return "대용량 퀵드로우 탄창";
        if (origLower.contains("extended mag") || keyLower.contains("extended")) return "대용량 탄창";
        if (origLower.contains("quickdraw mag") || keyLower.contains("quickdraw")) return "퀵드로우 탄창";

        // 6. 무기 예외 처리
        if (keyLower.contains("panzerfaust100m")) return "판처파우스트";
        if (keyLower.contains("m416") || keyLower.contains("hk416")) return "M416";
        if (keyLower.contains("qbu88")) return "QBU88";
        if (keyLower.contains("pan")) return "프라이팬";
        if (keyLower.contains("machete")) return "마체테";
        if (keyLower.contains("crowbar") || keyLower.contains("cowbar")) return "빠루";
        if (keyLower.contains("sickle")) return "낫";

        return originalName; 
    }

    private boolean isValidImageUrl(String urlString) {
        try {
            URL url = new URL(urlString);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("HEAD"); 
            connection.setConnectTimeout(2000); 
            connection.setReadTimeout(2000);
            
            int responseCode = connection.getResponseCode();
            return (responseCode >= 200 && responseCode < 300); 
        } catch (Exception e) {
            return false;
        }
    }
    
    private void setCategoryInfo(BagItemInfoVO item, String itemKey) {
        int categoryNo = 5; 
        String itemType = "기타/소모품";
        String keyLower = itemKey.toLowerCase();
        
        if (keyLower.contains("grenade") || keyLower.contains("smoke") || 
            keyLower.contains("flashbang") || keyLower.contains("molotov") || 
            keyLower.contains("c4") || keyLower.contains("sticky") ||
            keyLower.contains("spiketrap") || keyLower.contains("rock") || 
            keyLower.contains("apple") || keyLower.contains("snowball")) {
            categoryNo = 5;
            itemType = "투척무기";
        }
        else if (keyLower.contains("attach") || keyLower.contains("scope") || 
                 keyLower.contains("muzzle") || keyLower.contains("grip") || 
                 keyLower.contains("stock") || keyLower.contains("magazine")) {
            categoryNo = 2; 
            itemType = "부착물";
        } 
        else if (keyLower.contains("traumabag") || keyLower.contains("tacpack") || keyLower.contains("ghillie")) {
            categoryNo = 4;
            itemType = "방어구/장비";
        }
        else if (keyLower.contains("mountainbike")) {
            categoryNo = 5;
            itemType = "소모품/기타";
        }
        else if (keyLower.contains("weapon") || keyLower.contains("weap")) {
            categoryNo = 1; 
            itemType = "무기";
        } 
        else if (keyLower.contains("ammo")) {
            categoryNo = 3; 
            itemType = "탄약";
        } 
        else if (keyLower.contains("armor") || keyLower.contains("head") || 
                 keyLower.contains("vest") || keyLower.contains("helmet") || 
                 keyLower.contains("backpack") || keyLower.contains("back_") || 
                 keyLower.contains("equip") || keyLower.contains("parachute")) {
            categoryNo = 4; 
            itemType = "방어구";
        } 
        else if (keyLower.contains("heal") || keyLower.contains("boost") || 
                 keyLower.contains("energy") || keyLower.contains("painkiller") ||
                 keyLower.contains("fuel") || keyLower.contains("drone")) {
            categoryNo = 5; 
            itemType = "회복/소모품";
        }

        item.setCategoryNo(categoryNo);
        item.setItemType(itemType);
    }

    private String generateImageUrl(String itemKey) {
        String keyLower = itemKey.toLowerCase();
        
        // =========================================================================
        // 강제 고정 영역
        // =========================================================================
        
        // ⭐ 수류탄 (투척물) - 오직 정확히 일치할 때만 고정 링크 반환!
        if (keyLower.equals("item_weapon_grenade_c")) {
            return "https://raw.githubusercontent.com/pubg/api-assets/refs/heads/master/Assets/Item/Equipment/Throwable/Item_Weapon_Grenade_C.png";
        }
        
        // 눈덩이 (투척물)
        if (keyLower.contains("item_weapon_snowball")) {
            return "https://raw.githubusercontent.com/pubg/api-assets/refs/heads/master/Assets/Item/Equipment/Throwable/Item_Weapon_Snowball_C.png";
        }
        // 판처파우스트 (주무기)
        if (keyLower.contains("panzerfaust100m")) {
            return "https://raw.githubusercontent.com/pubg/api-assets/refs/heads/master/Assets/Item/Weapon/Main/Item_Weapon_PanzerFaust100M_C.png";
        }
        // QBU88 (주무기)
        if (keyLower.contains("qbu88")) {
            return "https://raw.githubusercontent.com/pubg/api-assets/refs/heads/master/Assets/Item/Weapon/Main/Item_Weapon_QBU88_C.png";
        }
        // M416 / HK416 (주무기)
        if (keyLower.contains("m416") || keyLower.contains("hk416")) {
            return "https://raw.githubusercontent.com/pubg/api-assets/refs/heads/master/Assets/Item/Weapon/Main/Item_Weapon_HK416_C.png";
        }
        // 3레벨 가방
        if (keyLower.contains("back_c_01_lv3")) {
            return "https://raw.githubusercontent.com/pubg/api-assets/refs/heads/master/Assets/Item/Equipment/Backpack/Item_Back_C_01_Lv3_C.png";
        }
        // 57mm 탄약
        if (keyLower.contains("item_ammo_57mm")) {
            return "https://raw.githubusercontent.com/pubg/api-assets/refs/heads/master/Assets/Item/Ammunition/None/item_Ammo_57mm_c.png";
        }
        // 40mm 탄약
        if (keyLower.contains("item_ammo_40mm")) {
            return "https://raw.githubusercontent.com/pubg/api-assets/refs/heads/master/Assets/Item/Ammunition/None/item_Ammo_40mm_C.png";
        }

        // =========================================================================
        // 나머지 일반 아이템 처리 (동적 생성)
        // =========================================================================
        String imageBaseUrl = "https://raw.githubusercontent.com/pubg/api-assets/refs/heads/master/Assets/Item/";
        String folderPath = "";
        
        if (keyLower.contains("grenade") || keyLower.contains("smoke") || 
            keyLower.contains("flashbang") || keyLower.contains("molotov") || 
            keyLower.contains("c4") || keyLower.contains("sticky") ||
            keyLower.contains("spiketrap") || keyLower.contains("rock") || 
            keyLower.contains("apple")) {
            folderPath = "Equipment/Throwable/";
        }
        else if (keyLower.contains("attach") || keyLower.contains("scope") || keyLower.contains("muzzle") || 
                 keyLower.contains("grip") || keyLower.contains("stock") || keyLower.contains("magazine")) {
            folderPath = "Attachment/";
        } 
        else if (keyLower.contains("ghillie")) {
             folderPath = "Equipment/Jacket/";
        } else if (keyLower.contains("traumabag") || keyLower.contains("tacpack") || keyLower.contains("mountainbike")) {
             folderPath = "Equipment/Backpack/"; 
        }
        else if (keyLower.contains("weapon") || keyLower.contains("weap")) {
            if (keyLower.contains("handgun") || keyLower.contains("pistol") || keyLower.contains("revolver") ||
                keyLower.contains("stungun") || keyLower.contains("vz61skorpion") || keyLower.contains("sawnoff") || 
                keyLower.contains("rhino") || keyLower.contains("nagantm1895") || keyLower.contains("m9") || 
                keyLower.contains("m79") || keyLower.contains("m1911") || keyLower.contains("g18") || 
                keyLower.contains("flaregun") || keyLower.contains("deserteagle")) {
                folderPath = "Weapon/Handgun/";
            } 
            else if (keyLower.contains("melee") || keyLower.contains("pan") || 
                     keyLower.contains("sickle") || keyLower.contains("machete") || keyLower.contains("cowbar")) {
                folderPath = "Weapon/Melee/";
            } 
            else {
                folderPath = "Weapon/Main/"; 
            }
        }
        else if (keyLower.contains("ammo")) {
            folderPath = "Ammunition/None/";
        } 
        else if (keyLower.contains("backpack") || keyLower.contains("back_") || keyLower.contains("parachute")) {
            folderPath = "Equipment/Backpack/";
        } else if (keyLower.contains("head") || keyLower.contains("helmet")) {
            folderPath = "Equipment/Headgear/";
        } else if (keyLower.contains("vest") || keyLower.contains("armor")) {
            folderPath = "Equipment/Vest/";
        }
        else if (keyLower.contains("boost") || keyLower.contains("energy") || 
                 keyLower.contains("painkiller") || keyLower.contains("adrenaline")) {
            folderPath = "Use/Boost/";
        } else if (keyLower.contains("heal") || keyLower.contains("bandage") || 
                   keyLower.contains("firstaid") || keyLower.contains("medkit")) {
            folderPath = "Use/Heal/";
        } else if (keyLower.contains("gascan") || keyLower.contains("jerrycan")) {
            folderPath = "Use/Fuel/";
        } else {
            folderPath = "Use/Gadget/"; 
        }

        return imageBaseUrl + folderPath + itemKey + ".png";
    }
}