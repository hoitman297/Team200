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

                    String description = getItemDescription(koreanName);
                    
                    BagItemInfoVO item = new BagItemInfoVO();
                    item.setItemName(koreanName); 
                    item.setItemInfo(description); 
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
    
 // ⭐ 한글 및 영문 아이템 이름을 기반으로 실제 게임 설명을 반환하는 메서드
    private String getItemDescription(String itemName) {
        // 대소문자 띄어쓰기 꼬임을 최소화하기 위해 모두 대문자로 변환 후 검사
        switch (itemName.toUpperCase()) {
            
            // ==========================================
            // [1] 돌격소총 (AR)
            // ==========================================
            case "AKM": return "강력한 7.62mm 탄약을 사용하는 돌격소총입니다. 반동이 크지만 근접전에서 파괴력이 뛰어납니다.";
            case "M16A4": return "5.56mm 탄약을 사용하며 점사와 단발만 지원합니다. 탄속이 빠르고 장거리 교전에 유리합니다.";
            case "SCAR-L": return "5.56mm 탄약을 사용하며 반동 제어가 쉬워 초보자에게 추천되는 안정적인 돌격소총입니다.";
            case "M416":
            case "HK416": return "5.56mm 돌격소총의 표준입니다. 파츠를 모두 모으면 완벽한 밸런스를 자랑하는 만능 총기입니다.";
            case "GROZA": return "보급상자 전용 7.62mm 돌격소총으로, 무시무시한 연사력과 화력으로 초근접전을 지배합니다.";
            case "AUG": return "5.56mm 돌격소총으로 탄속이 빠르고 반동 제어가 수월하여 안정성이 뛰어납니다.";
            case "QBZ":
            case "QBZ95": return "사녹 맵 전용 5.56mm 돌격소총으로 SCAR-L을 대체하며, 준수한 안정성을 보여줍니다.";
            case "베릴 M762": return "7.62mm 돌격소총으로 반동이 매우 강하지만, 연사력이 빨라 근접전 최강의 화력을 뽐냅니다.";
            case "MK47 MUTANT": return "7.62mm 탄약을 사용하며 2점사와 단발만 지원하는 특수 목적 돌격소총입니다.";
            case "G36C": return "비켄디 맵 전용 5.56mm 돌격소총으로, 무난한 반동과 연사력을 가졌습니다.";
            case "K2": return "태이고 맵 등에서 등장하는 5.56mm 한국형 돌격소총으로, 무난한 성능을 갖췄습니다.";
            case "FAMAS": return "보급상자에서 획득 가능한 5.56mm 돌격소총으로 엄청난 연사속도와 파괴력을 지녔습니다.";
            case "ACE32": return "7.62mm 탄약을 사용하는 돌격소총으로, 베릴보다 반동 제어가 수월하여 다루기 쉽습니다.";

            // ==========================================
            // [2] 지정사수소총 (DMR)
            // ==========================================
            case "SKS": return "7.62mm 탄약을 사용하는 반자동 지정사수소총입니다. 파츠 의존도가 높지만 화력이 강합니다.";
            case "VSS": return "9mm 탄약을 사용하며 소음기와 스코프가 기본 장착되어 있는 암살용 특수 총기입니다.";
            case "MINI 14":
            case "MINI14": return "5.56mm 탄약을 사용하며 탄속이 가장 빠르고 반동이 적어 연속 사격에 유리합니다.";
            case "MK14 EBR":
            case "MK14": return "보급상자 전용 7.62mm DMR로, 엎드려 쏠 때 양각대가 펴지며 '자동' 연사 모드를 지원하는 괴물 총기입니다.";
            case "SLR": return "7.62mm 탄약을 사용하는 강력한 DMR로 SKS보다 데미지가 높지만 반동이 큽니다.";
            case "QBU88": return "사녹 전용 5.56mm DMR로 양각대가 달려 있어 엎드려 쏠 때 반동이 극도로 줄어듭니다.";
            case "MK12": return "5.56mm 탄약을 사용하며 엎드려 쏠 때 양각대가 적용되는 매우 안정적인 DMR입니다.";
            case "드라구노프": return "7.62mm 탄약을 사용하는 강력한 DMR로, 2레벨 헬멧을 쓴 적을 확률적으로 한 방에 눕힐 수 있습니다.";

            // ==========================================
            // [3] 저격소총 (SR)
            // ==========================================
            case "KAR98K": return "필드에서 흔히 볼 수 있는 7.62mm 볼트액션 저격소총입니다. 2레벨 헬멧을 한 방에 관통합니다.";
            case "M24": return "Kar98k보다 탄속이 빠르고 장탄수 확장이 가능한 강력한 7.62mm 저격소총입니다.";
            case "AWM": return "보급상자 전용 총기로, 배틀그라운드 내 유일하게 3레벨 헬멧을 한 방에 뚫어버리는 최강의 저격소총입니다.";
            case "WIN94":
            case "WINCHESTER MODEL 1894": return ".45 ACP 탄약을 사용하는 레버액션 소총으로, 2.7배율 고정 스코프가 장착되어 있습니다.";
            case "모신나강": return "Kar98k와 완전히 동일한 스탯과 성능을 가진 7.62mm 볼트액션 저격소총입니다.";
            case "링스 AMR": return "보급상자 전용 대물 저격총으로, BRDM 등 차량을 뚫어버릴 수 있는 강력한 무기입니다.";

            // ==========================================
            // [4] 기관단총 (SMG)
            // ==========================================
            case "마이크로 UZI": return "9mm 탄약을 사용하며 연사력이 매우 빨라 초근접전에서 엄청난 화력을 뿜어내는 기관단총입니다.";
            case "UMP45": return ".45 ACP 탄약을 사용하며, SMG 중 가장 안정적이고 사거리가 길어 다루기 쉽습니다.";
            case "벡터": return "엄청난 연사력과 레이저 같은 명중률을 가졌지만, 기본 탄창 용량이 매우 적어 대용량 탄창이 필수입니다.";
            case "토미건": return ".45 ACP 탄약을 사용하며 대용량 탄창 장착 시 50발의 넉넉한 장탄수를 자랑합니다.";
            case "PP-19 비존": return "9mm 탄약을 사용하며 파츠 없이도 53발의 장탄수를 가진 든든한 기관단총입니다.";
            case "MP5K": return "9mm 기관단총으로 각종 파츠를 달 수 있어 연사력과 안정성이 모두 훌륭합니다.";
            case "P90": return "보급상자 전용 기관단총으로, 전용 5.7mm 탄약을 사용하며 50발의 넉넉한 탄창과 무반동에 가까운 성능을 냅니다.";
            case "JS9": return "론도 맵 전용 9mm 기관단총으로, 강력한 화력과 매우 적은 반동을 자랑합니다.";
            case "UMP9": return "9mm 탄약을 사용하는 기관단총으로, 반동이 적고 안정성이 뛰어납니다. (현 UMP45의 이전 명칭)";
            case "MP9": return "9mm 탄약을 사용하는 기관단총으로, 소음기와 레이저 포인터가 기본 장착되어 반동 제어가 매우 쉽습니다.";

            // ==========================================
            // [5] 산탄총 (SG)
            // ==========================================
            case "S686": return "12게이지를 사용하는 더블 배럴 산탄총입니다. 두 발을 순식간에 발사하여 초근접 최강의 화력을 냅니다.";
            case "S1897": return "12게이지 펌프액션 산탄총으로 5발이 장전되며, 장전 중 끊고 사격이 가능합니다.";
            case "S12K": return "12게이지를 사용하는 반자동 산탄총으로 AR 파츠(탄창, 스코프)를 장착할 수 있고 다수 교전에 유리합니다.";
            case "DBS": return "보급 및 필드에서 등장하는 펌프액션 더블 배럴 산탄총으로, 무려 14발의 장탄수를 자랑합니다.";
            case "O12": return "12게이지 슬러그탄을 사용하는 산탄총으로 연사가 가능하여 중거리까지 커버 가능한 화력을 보여줍니다.";

            // ==========================================
            // [6] 경기관총 (LMG)
            // ==========================================
            case "DP-28": return "7.62mm 탄약을 사용하는 원판형 기관총으로, 엎드려 쏠 때 양각대가 펴져 명중률이 대폭 상승합니다.";
            case "M249": return "5.56mm 탄약을 사용하며 대용량 탄창 장착 시 무려 150발을 쏟아낼 수 있는 거점 방어 및 차량 폭파용 기관총입니다.";
            case "MG3": return "보급상자 전용 7.62mm 기관총으로, 660RPM과 990RPM으로 압도적인 연사 속도를 조절할 수 있습니다.";

            // ==========================================
            // [7] 특수 무기 및 권총류
            // ==========================================
            case "석궁": return "발사 소음이 완벽히 없는 무기로, 3레벨 헬멧도 한 방에 뚫어버리는 숨겨진 흉기입니다.";
            case "플레어건": return "하늘을 향해 쏘면 무기 보급상자나 방탄 UAZ를 호출하는 매우 희귀한 아이템입니다.";
            case "PANZERFAUST":
            case "판처파우스트": return "일회용 대전차 로켓입니다. 강력한 광역 피해를 주지만, 발사 시 후폭풍이 있어 등 뒤 아군이 다칠 수 있습니다.";
            case "데저트이글": return "배틀그라운드에서 가장 강력한 데미지를 자랑하는 권총입니다.";
            case "스콜피온": return "권총 슬롯에 장착할 수 있는 9mm 미니 기관단총으로 연사가 가능합니다.";
            case "P18C": return "9mm 탄약을 사용하며 연사(Auto) 모드를 지원하여 급할 때 SMG처럼 쓸 수 있는 권총입니다.";
            case "소드오프": return "권총 슬롯에 장착되는 소형 더블 배럴 산탄총입니다.";
            case "박격포" : return "대한민국 국군의 제식 박격포.";
            case "M79": return "권총 슬롯에 장착하는 특수 무기로, 40mm 연막탄을 발사하여 원거리에 연막을 전개할 수 있습니다.";
            case "P92": return "9mm 탄약을 사용하는 가장 기본적인 반자동 권총입니다. 대용량 탄창 장착 시 20발까지 사격 가능합니다.";
            case "R1895": return "7.62mm 탄약을 사용하는 강력한 리볼버로 데미지가 높지만, 한 발씩 장전하므로 속도가 매우 느립니다.";
            case "P1911": return ".45 ACP 탄약을 사용하는 고전적인 반자동 권총입니다. P92보다 데미지가 강하지만 기본 장탄수가 7발로 적습니다.";
            case "R45": return ".45 ACP 탄약을 사용하는 6연발 리볼버입니다. 스피드로더를 사용하여 재장전이 빠르고 레드 도트를 장착할 수 있습니다.";
            
            // ==========================================
            // [8] 소모품, 방어구, 부착물 (기존 한글 데이터)
            // ==========================================
            case "눈덩이": return "비켄디 등 겨울 테마 맵에서 획득할 수 있는 투척물로, 피해량은 없지만 재미로 던질 수 있습니다.";
            case "수류탄": return "핀을 뽑고 던지면 일정 시간 후 폭발하여 광역 피해를 줍니다. R키를 눌러 쿠킹(지연 폭발)이 가능합니다.";
            case "연막탄": return "넓은 범위에 시야를 차단하는 연막을 피워 올립니다. 아군을 살리거나 평지에서 은폐할 때 필수입니다.";
            case "섬광탄": return "폭발 시 주변 적의 시야와 청각을 일시적으로 마비시킵니다. 건물 진입 시 매우 유용합니다.";
            case "화염병": return "투척 시 바닥에 불길을 생성하여 범위 내의 적에게 지속적인 화상 피해를 입힙니다. 나무 문을 파괴할 수 있습니다.";
            case "점착 폭탄": return "벽이나 차량 등에 부착할 수 있는 폭탄으로, 파괴 가능한 벽을 뚫을 수 있습니다. 특정 맵에서만 등장합니다.";
            case "C4": return "매우 넓은 범위에 강력한 폭발을 일으키며 건물 관통 피해를 줍니다. 폭발까지 시간이 다소 오래 걸립니다.";
            case "사과": return "대기실에서 심심풀이로 던질 수 있는 과일입니다.";
            case "스파이크 트랩": return "도로에 설치하여 지나가는 차량의 타이어를 터뜨릴 수 있는 전술 함정입니다.";
            case "교란 수류탄": return "던지면 가짜 총소리를 내어 적에게 혼란을 주는 전술 투척물입니다.";
            case "돌멩이": return "훈련장 등 특정 구역에서 가볍게 던질 수 있는 돌멩이입니다.";

            case "에너지 드링크": return "부스트 게이지를 40 올려줍니다. 시전 시간이 짧아 교전 중 빠르게 마시기 좋습니다.";
            case "진통제": return "부스트 게이지를 60 올려줍니다. 지속적인 체력 회복과 약간의 이동 속도 증가 효과를 제공합니다.";
            case "아드레날린 주사기": return "부스트 게이지를 100(최대치)으로 즉시 채워주어 지속 회복과 이동 속도 대폭 증가 효과를 줍니다.";
            case "붕대": return "사용 시 체력을 10%씩 서서히 회복합니다. 최대 75%까지만 회복할 수 있습니다.";
            case "구급상자": return "사용 시 체력을 최대 75%까지 한 번에 회복합니다. 시전 시간이 6초로 긴 편입니다.";
            case "의료용 키트": return "사용 시 체력을 100% 끝까지 완전히 회복하는 최고급 회복 아이템입니다.";
            case "연료통": return "탑승물의 연료를 보충하거나 바닥에 흘려 불을 붙일 수 있으며, 쏴서 폭발시킬 수도 있습니다.";
            
            case "헬멧 (LV.1)": return "1레벨 헬멧(오토바이 헬멧)으로, 머리에 받는 피해를 일정 부분 줄여줍니다.";
            case "헬멧 (LV.2)": return "2레벨 헬멧(군용 헬멧)으로, 가장 보편적으로 사용되는 든든한 방어구입니다.";
            case "헬멧 (LV.3)": return "일명 '3뚝'. 강력한 스나이퍼 소총(Kar98k, M24)의 헤드샷을 1회 막아주어 생존력을 극대화합니다.";
            case "경찰 조끼 (LV.1)": return "1레벨 조끼로, 약간의 몸통 피해 감소와 50의 추가 인벤토리 용량을 제공합니다.";
            case "경찰 조끼 (LV.2)": return "2레벨 조끼로, 준수한 방어력과 추가 용량을 제공하는 표준 방어구입니다.";
            case "군용 조끼 (LV.3)": return "일명 '3조끼'. 몸통 피해량을 무려 55%나 감소시키고 인벤토리 용량을 대폭 늘려줍니다.";
            case "배낭 (LV.1)": return "소형 배낭으로, 기본적인 아이템들을 담을 수 있는 추가 용량을 제공합니다.";
            case "배낭 (LV.2)": return "중형 배낭으로, 여유로운 인벤토리 공간을 제공하여 가장 널리 쓰이는 배낭입니다.";
            case "배낭 (LV.3)": return "가장 많은 아이템을 담을 수 있는 대형 배낭입니다. 단, 풀숲에서 눈에 잘 띌 수 있습니다.";
            case "길리 슈트": return "보급상자에서만 획득 가능한 위장복으로, 주변 지형과 완벽하게 동화되어 적의 눈을 속입니다.";
            case "낙하산": return "비행기에서 낙하하거나 비상 호출(푸얼턴) 시 사용하는 기본 생존 장비입니다.";

            case "5.56MM 탄약": return "M416, SCAR-L, Mini14 등에 사용되는 가볍고 탄속이 빠른 5탄입니다.";
            case "7.62MM 탄약": return "AKM, Beryl M762, Kar98k 등에 사용되며 무겁지만 한 발당 데미지가 강력한 7탄입니다.";
            case "9MM 탄약": return "UZI, Vector 등 기관단총(SMG)과 권총에 주로 사용되는 가벼운 탄약입니다.";
            case ".45 ACP 탄약": return "콜트 등 권총에 사용되는 탄약입니다.";
            case "12 게이지": return "산탄총(샷건) 전용 탄약으로, 한 발을 쏘면 여러 개의 펠릿이 흩어져 나갑니다.";
            case ".300 매그넘": return "보급상자 전용 무기인 AWM에만 사용되는 현존 최고 위력의 특수 탄약입니다.";
            case "57MM 탄약": return "보급상자 무기인 P90 전용 고속 탄약입니다.";
            case "40MM 탄약": return "연막 유탄 발사기 등에 사용되는 특수 목적 탄약입니다.";

            case "15배율 스코프": return "보급상자에서만 등장하는 최고 배율 스코프입니다. 엄청난 장거리 저격이 가능합니다.";
            case "8배율 스코프": return "저격소총(SR)과 지정사수소총(DMR)에 장착 가능한 장거리용 핵심 조준경입니다.";
            case "6배율 스코프": return "줌 조절이 가능하여 연사와 저격 모두에 유용한 다목적 배율 조준경입니다.";
            case "4배율 스코프": return "중장거리 교전에 특화된 ACOG 조준경입니다. AR과 DMR에 가장 많이 쓰입니다.";
            case "3배율 스코프": return "돌격소총(AR) 연사 시 가장 선호되는 배율 조준경 중 하나로 시야가 깨끗합니다.";
            case "2배율 스코프": return "근~중거리 교전에 적합한 둥근 모양의 조준경입니다.";
            case "레드 도트 사이트": return "근거리 교전에 필수적인 무배율 조준경으로, 조준 속도를 높여주고 깔끔한 시야를 제공합니다.";
            case "홀로그램 조준경": return "근거리 조준 시 시야각은 좁지만 표적 획득(조준점 일치)이 쉬운 무배율 조준경입니다.";

            case "수직 손잡이": return "총기의 수직 반동(위로 튀는 현상)을 크게 잡아주어 단발 사격이나 연사 제어에 특화되어 있습니다.";
            case "앵글 손잡이": return "총기의 좌우 수평 반동을 줄여주고 정조준(ADS) 속도를 약간 높여줍니다.";
            case "하프 그립": return "수직/수평 반동을 모두 잡아주어 AR 연사 시 가장 밸런스 좋은 성능을 보여줍니다.";
            case "라이트 그립": return "단발 사격 후 조준점 회복 속도가 빨라져 SKS 등 DMR 총기에 찰떡궁합인 그립입니다.";
            case "엄지 그립": return "정조준(ADS) 속도를 극단적으로 높여주어 기습적인 근접 교전에 매우 유리합니다.";
            case "레이저 포인트": return "견착 및 지향 사격 시 탄퍼짐을 크게 줄여주는 근접전용 부착물입니다.";
            case "전술 개머리판": return "M416과 Vector 등에 장착되며, 반동 회복과 무기 흔들림을 대폭 개선하는 필수 부착물입니다.";
            case "UZI 개머리판": return "Micro UZI와 스콜피온 전용 개머리판으로 반동을 줄여줍니다.";
            case "화살통 (석궁)": return "석궁 전용 부착물로 재장전 속도를 무려 30%나 줄여줍니다.";
            case "칙패드": return "저격소총(SR/DMR)의 수직 반동을 줄이고 조준 시 호흡 흔들림을 잡아줍니다.";
            case "탄띠": return "Kar98k, 산탄총 등에 장착하여 총알 한 발씩 넣는 재장전 속도를 크게 단축시킵니다.";
            case "중량 개머리판": return "무기의 반동 제어력을 대폭 올려주지만 정조준 속도가 조금 느려지는 파츠입니다.";

            case "보정기": return "총구의 수직 및 수평 반동을 대폭 줄여주어 연사 제어를 매우 쉽게 만들어주는 핵심 부착물입니다.";
            case "소염기": return "총구 화염을 숨겨주고 반동도 소폭 줄여주는 유용한 밸런스형 부착물입니다.";
            case "소음기": return "총성(소리)과 화염을 억제하여 적이 내 위치를 파악하기 어렵게 만듭니다. 암살에 특화되어 있습니다.";
            case "초크": return "산탄총(샷건)의 탄퍼짐을 좁혀주어 유효 사거리를 크게 늘려주는 필수 부착물입니다.";
            case "덕빌": return "산탄총의 펠릿을 세로에서 가로로 넓게 퍼지게 만들어 움직이는 적을 맞추기 쉽게 해줍니다.";
            case "대용량 퀵드로우 탄창": return "장탄수를 늘려주고 재장전 속도까지 단축시키는 가장 완벽한 탄창입니다. (일명 대퀵)";
            case "대용량 탄창": return "총기의 기본 장탄수를 늘려주어 한 번의 탄창으로 더 많은 적과 싸울 수 있게 해줍니다.";
            case "퀵드로우 탄창": return "총기의 재장전 속도를 눈에 띄게 단축시켜 줍니다.";

            case "프라이팬": return "배틀그라운드의 상징적인 근접 무기입니다. 엉덩이에 차고 있으면 날아오는 총알을 완벽하게 튕겨내는 절대 방어구 역할을 합니다.";
            case "마체테": return "정글도 형태의 근접 무기입니다. 급할 땐 조준하여 적에게 투척할 수도 있습니다.";
            case "빠루": return "쇠지렛대 형태의 근접 무기로, 자물쇠가 걸린 비밀 방(시크릿 룸)을 열거나 적을 타격할 수 있습니다.";
            case "낫": return "농기구 형태의 근접 무기로, 무기로 타격하거나 투척할 수 있습니다.";

            // 위 목록에 명시되지 않은 데이터 처리용 기본값
            default:
                if (itemName.contains("권총") || itemName.contains("Pistol")) {
                    return "보조 무기로 활용할 수 있는 권총류입니다.";
                } else if (itemName.contains("탄약") || itemName.contains("게이지") || itemName.contains("매그넘")) {
                    return "총기에 사용하는 탄약입니다. 가방의 용량을 차지하므로 필요한 만큼만 소지하세요.";
                } else if (itemName.contains("헬멧") || itemName.contains("Helmet")) {
                    return "헤드샷으로 받는 피해량을 줄여주는 방어구입니다.";
                } else if (itemName.contains("조끼") || itemName.contains("Vest")) {
                    return "몸통으로 받는 피해량을 줄이고 가방의 기본 용량을 늘려줍니다.";
                } else if (itemName.contains("배낭") || itemName.contains("Backpack")) {
                    return "파밍할 수 있는 아이템의 최대 용량을 늘려줍니다.";
                } else if (itemName.contains("스코프") || itemName.contains("Scope")) {
                    return "원거리의 적을 조준할 때 시야를 확대해 주는 배율 조준경입니다.";
                }
                return "배틀그라운드 전장에서 생존에 필요한 무기/아이템입니다.";
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
            if (origLower.contains("jammer pack")) return "낙하산";
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
        if (keyLower.contains("m79")) return "M79";
        if (keyLower.contains("p92")) return "P92";
        if (keyLower.contains("m1911") || keyLower.contains("p1911")) return "P1911";
        if (keyLower.contains("rhino") || keyLower.contains("r45")) return "R45";
        if (keyLower.contains("mp9")) return "MP9";
        if (keyLower.contains("nagantm1895") || origLower.contains("r1895")) return "R1895";
        if (keyLower.contains("ump9")) return "UMP9";
        
        if (keyLower.contains("aug")) return "AUG";
        if (origLower.contains("deagle")) return "데저트이글";
        if (origLower.contains("bizon")) return "PP-19 비존";
        if (keyLower.contains("beryl")) return "베릴 M762";
        if (keyLower.contains("crossbow")) return "석궁";
        if (keyLower.contains("dragunov")) return "드라구노프";
        if (keyLower.contains("flare")) return "플레어건";
        if (origLower.contains("lynx amr")) return "링스 AMR";
        if (origLower.contains("mortar")) return "박격포";
        if (keyLower.contains("mosin")) return "모신나강";
        if (origLower.contains("sawed-off")) return "소드오프";
        if (origLower.contains("tommy gun")) return "토미건";
        if (keyLower.contains("panzerfaust")) return "판처파우스트";
        if (keyLower.contains("uzi") && keyLower.contains("weapon")) return "마이크로 UZI";
        if (keyLower.contains("vector")) return "벡터";
        if (keyLower.contains("skorpion")) return "스콜피온";
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