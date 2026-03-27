package com.semi.spring.overwatch.model.service;

import java.util.List;
import com.semi.spring.overwatch.model.vo.HeroSkillsVO;
import com.semi.spring.overwatch.model.vo.HeroSkinVO;
import com.semi.spring.overwatch.model.vo.HeroVO;

public interface OverwatchService {
    List<HeroVO> selectHeroList();
    HeroVO selectHero(int heroNo);
    HeroSkillsVO selectHeroSkills(int heroNo);
	List<HeroSkinVO> getHeroSkinList(int heroNo);
}