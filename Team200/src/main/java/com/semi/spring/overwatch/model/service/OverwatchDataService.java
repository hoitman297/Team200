package com.semi.spring.overwatch.model.service;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.semi.spring.overwatch.model.dao.OverwatchDao;
import com.semi.spring.overwatch.model.vo.HeroSkillsVO;
import com.semi.spring.overwatch.model.vo.HeroVO;

@Service
public class OverwatchDataService {

    @Autowired
    private OverwatchDao overdao;

    @PostConstruct
    public void init() {
        int count = overdao.checkHeroCount();
        
        if (count == 0) {
            System.out.println("=== 오버워치 영웅 DB가 비어있어 API 데이터를 가져옵니다 ===");
            new Thread(() -> updateHeroData()).start();
        } else {
            System.out.println("=== 이미 " + count + "개의 오버워치 영웅 데이터가 있어 업데이트를 건너띔 ===");
        }
    }

    public void updateHeroData() {
        try {
            RestTemplate restTemplate = new RestTemplate();
            ObjectMapper objectMapper = new ObjectMapper();

            // 1. 전체 영웅 목록 리스트 가져오기 (한국어 패치 적용)
            String listUrl = "https://overfast-api.tekrop.fr/heroes?locale=ko-kr";
            String listJson = restTemplate.getForObject(listUrl, String.class);
            JsonNode heroArray = objectMapper.readTree(listJson);

            int insertCount = 0;

            // 2. 각 영웅의 상세 정보(스킬, 체력 등)를 순회하며 가져오기
            for (JsonNode basicNode : heroArray) {
                String heroKey = basicNode.get("key").asText();
                String detailUrl = "https://overfast-api.tekrop.fr/heroes/" + heroKey + "?locale=ko-kr";
                
                String detailJson = restTemplate.getForObject(detailUrl, String.class);
                JsonNode detailNode = objectMapper.readTree(detailJson);

                // --- [1단계] HERO_INFO 데이터 세팅 및 저장 ---
                HeroVO hero = new HeroVO();
                hero.setHeroName(detailNode.get("name").asText());
                hero.setHeroIntro(detailNode.get("description").asText());
                
                String apiRole = detailNode.get("role").asText().toLowerCase();
                hero.setHeroPosition(apiRole.equals("tank") ? "탱커" : apiRole.equals("damage") ? "딜러" : apiRole.equals("support") ? "힐러" : apiRole); 
                hero.setHeroImg(detailNode.get("portrait").asText());
                hero.setHeroHp(detailNode.path("hitpoints").path("total").asInt(200));

                overdao.insertHero(hero);
                int currentHeroNo = hero.getHeroNo();

                // --- [2단계] HERO_SKILLS_INFO 데이터 세팅 (100% 자동 매핑) ---
                HeroSkillsVO skills = new HeroSkillsVO();
                skills.setHeroNo(currentHeroNo);

                JsonNode abilities = detailNode.get("abilities");
                
                if (abilities != null && abilities.size() > 0) {
                    // API에서 주는 배열 순서대로 0번부터 최대 6번(패시브)까지 순차적으로 꽂아 넣습니다.
                    for (int i = 0; i < abilities.size(); i++) {
                        JsonNode abil = abilities.get(i);
                        String name = abil.path("name").asText();
                        String desc = abil.path("description").asText();
                        String icon = abil.path("icon").asText();

                        switch (i) {
                            case 0:
                                skills.setSkillLclickName(name);
                                skills.setSkillLclickDesc(desc);
                                skills.setSkillLclickImg(icon);
                                break;
                            case 1:
                                skills.setSkillRclickName(name);
                                skills.setSkillRclickDesc(desc);
                                skills.setSkillRclickImg(icon);
                                break;
                            case 2:
                                skills.setSkillShiftName(name);
                                skills.setSkillShiftDesc(desc);
                                skills.setSkillShiftImg(icon);
                                break;
                            case 3:
                                skills.setSkillEName(name);
                                skills.setSkillEDesc(desc);
                                skills.setSkillEImg(icon);
                                break;
                            case 4:
                                skills.setSkillQName(name);
                                skills.setSkillQDesc(desc);
                                skills.setSkillQImg(icon);
                                break;
                            case 5:
                                skills.setSkillPName(name);
                                skills.setSkillPDesc(desc);
                                skills.setSkillPImg(icon);
                                break;
                            default:
                                // 스킬이 7개 이상인 영웅은 없으므로 무시
                                break;
                        }
                    }
                }
                
                // 스킬 정보 DB Insert
                overdao.insertHeroSkills(skills);
                insertCount++;
            }
            
            System.out.println("=== [성공] 총 " + insertCount + "명의 영웅 스킬  업데이트 완료 ===");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}