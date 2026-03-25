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
        // DB에 영웅 데이터가 있는지 확인
        int count = overdao.checkHeroCount();
        
        if (count == 0) {
            System.out.println("=== 오버워치 영웅 DB가 비어있어 API 데이터를 가져옵니다 ===");
            // 서버 부팅 속도 저하를 막기 위해 백그라운드 스레드에서 실행
            new Thread(() -> updateHeroData()).start();
        } else {
            System.out.println("=== 이미 " + count + "개의 오버워치 영웅 데이터가 있어 업데이트를 건너뜜 ===");
        }
    }

    public void updateHeroData() {
        try {
            RestTemplate restTemplate = new RestTemplate();
            ObjectMapper objectMapper = new ObjectMapper();

            // 1. 전체 영웅 목록 리스트 가져오기 (한국어 패치 적용 🇰🇷)
            String listUrl = "https://overfast-api.tekrop.fr/heroes?locale=ko-kr";
            String listJson = restTemplate.getForObject(listUrl, String.class);
            JsonNode heroArray = objectMapper.readTree(listJson);

            int insertCount = 0;

            // 2. 각 영웅의 상세 정보(스킬, 체력 등)를 순회하며 가져오기
            for (JsonNode basicNode : heroArray) {
                String heroKey = basicNode.get("key").asText();
                
                // 상세 정보 URL에도 한국어 패치 적용!
                String detailUrl = "https://overfast-api.tekrop.fr/heroes/" + heroKey + "?locale=ko-kr";
                
                String detailJson = restTemplate.getForObject(detailUrl, String.class);
                JsonNode detailNode = objectMapper.readTree(detailJson);

                // --- [1단계] HERO_INFO 데이터 세팅 및 저장 ---
                HeroVO hero = new HeroVO();
                hero.setHeroName(detailNode.get("name").asText());
                hero.setHeroIntro(detailNode.get("description").asText());
                
                // [수정] 영문 포지션을 한글로 변환
                String apiRole = detailNode.get("role").asText().toLowerCase();
                String krRole = "";
                
                switch (apiRole) {
                    case "tank":
                        krRole = "탱커";
                        break;
                    case "damage":
                        krRole = "딜러";
                        break;
                    case "support":
                        krRole = "힐러";
                        break;
                    default:
                        krRole = apiRole; // 기타 역할군 발생 시 원본 유지
                        break;
                }
                hero.setHeroPosition(krRole); 
                
                hero.setHeroImg(detailNode.get("portrait").asText());
                
                // 체력 세팅 (임시 체력, 방어력 등 합산)
                int totalHp = detailNode.path("hitpoints").path("total").asInt(200);
                hero.setHeroHp(totalHp);

                // 영웅 정보 DB Insert
                overdao.insertHero(hero);
                int currentHeroNo = hero.getHeroNo();

                // --- [2단계] HERO_SKILLS_INFO 데이터 세팅 및 저장 ---
                HeroSkillsVO skills = new HeroSkillsVO();
                skills.setHeroNo(currentHeroNo); // 받아온 PK 세팅

                JsonNode abilities = detailNode.get("abilities");
                
                // API의 스킬 배열을 순회하며 키 조작에 맞게 분배
                for (int i = 0; i < abilities.size(); i++) {
                    JsonNode abil = abilities.get(i);
                    String name = abil.get("name").asText();
                    String desc = abil.get("description").asText();
                    String icon = abil.get("icon").asText();

                    if (i == 0) {
                        skills.setSkillLclickName(name); 
                        skills.setSkillLclickDesc(desc); 
                        skills.setSkillLclickImg(icon);
                    } else if (i == 1) {
                        skills.setSkillShiftName(name); 
                        skills.setSkillShiftDesc(desc); 
                        skills.setSkillShiftImg(icon);
                    } else if (i == 2) {
                        skills.setSkillEName(name); 
                        skills.setSkillEDesc(desc); 
                        skills.setSkillEImg(icon);
                    } else if (i == abilities.size() - 1) { // 마지막을 궁극기(Q)로 가정
                        skills.setSkillQName(name); 
                        skills.setSkillQDesc(desc); 
                        skills.setSkillQImg(icon);
                    } else {
                        // 남는 스킬은 우클릭 등에 배정
                        skills.setSkillRclickName(name); 
                        skills.setSkillRclickDesc(desc); 
                        skills.setSkillRclickImg(icon);
                    }
                }
                
                // 스킬 정보 DB Insert
                overdao.insertHeroSkills(skills);
                insertCount++;
            }
            
            System.out.println("=== [성공] 총 " + insertCount + "명의 오버워치 영웅과 스킬을 DB에 저장했습니다! ===");

        } catch (Exception e) {
            System.out.println("=== [에러 발생] 오버워치 데이터 업데이트 중지: " + e.getMessage());
            e.printStackTrace();
        }
    }
}