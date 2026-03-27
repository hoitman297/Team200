package com.semi.spring.overwatch.model.dao;

import java.util.List;
import com.semi.spring.overwatch.model.vo.HeroSkillsVO;
import com.semi.spring.overwatch.model.vo.HeroSkinVO;
import com.semi.spring.overwatch.model.vo.HeroVO;

public interface OverwatchDao {

    // [API 데이터 동기화용]
    int checkHeroCount();
    void insertHero(HeroVO hero);
    void insertHeroSkills(HeroSkillsVO skills);

    // [JSP 화면 출력용]
    List<HeroVO> selectHeroList();          // 메인 화면: 전체 영웅 목록
    HeroVO selectHero(int heroNo);          // 상세 화면: 영웅 기본 정보
    HeroSkillsVO selectHeroSkills(int heroNo); // 상세 화면: 영웅 스킬 정보
	void insertHeroSkin(HeroSkinVO skin);
}