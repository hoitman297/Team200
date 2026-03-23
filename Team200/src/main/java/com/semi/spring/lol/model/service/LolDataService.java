package com.semi.spring.lol.model.service;

import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct; // 추가

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
// ... 기존 import들
import org.springframework.web.client.RestTemplate;

import com.semi.spring.lol.model.dao.LolDao;
import com.semi.spring.lol.model.vo.ChampionVO;

@Service
public class LolDataService {

    @Autowired
    private LolDao lolDao;

    // 서버가 켜지고 빈(Bean)이 생성된 직후에 자동으로 실행됨
    @PostConstruct
    public void init() {
        // 1. DB에서 현재 저장된 챔피언 리스트를 일단 가져와봐
        List<ChampionVO> list = lolDao.selectAllChampions();
        
        // 2. 리스트가 비어있을 때만(null이거나 size가 0일 때) 실행해!
        if(list == null || list.isEmpty()) {
            System.out.println("DB가 비어있어 API 데이터를 가져옵니다");
            updateChampionData();
        } else {
            // 데이터가 이미 있으면 실행 안 하고 넘어감
            System.out.println("이미 " + list.size() + "개의 데이터가 있어 업데이트를 건너뜁니다. ===");
        }
    }

    public void updateChampionData() {
        try {
            String url = "https://ddragon.leagueoflegends.com/cdn/16.1.1/data/ko_KR/champion.json";
            RestTemplate restTemplate = new RestTemplate();
            
            Map<String, Object> response = restTemplate.getForObject(url, Map.class);
            Map<String, Object> data = (Map<String, Object>) response.get("data");

            int insertCount = 0; // 몇 개 들어가는지 세보자
            for (String key : data.keySet()) {
                Map<String, Object> champInfo = (Map<String, Object>) data.get(key);
                
                ChampionVO vo = new ChampionVO();
                vo.setChampName((String) champInfo.get("name"));
                
                List<String> tags = (List<String>) champInfo.get("tags");
                vo.setChampPosition(String.join(", ", tags));
                
                String imgUrl = "https://ddragon.leagueoflegends.com/cdn/16.1.1/img/champion/" + key + ".png";
                vo.setChampImg(imgUrl);
                
                lolDao.insertChampion(vo);
                insertCount++; // 하나 넣을 때마다 카운트
            }
            System.out.println("=== [성공] 총 " + insertCount + "명의 챔피언을 DB에 저장했습니다! ===");
        } catch (Exception e) {
            System.out.println("=== [에러 발생] 중간에 멈춤: " + e.getMessage());
            e.printStackTrace(); // 어디서 터졌는지 정확히 보자
        }
    }
}