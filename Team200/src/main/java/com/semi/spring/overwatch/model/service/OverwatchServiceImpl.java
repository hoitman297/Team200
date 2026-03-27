package com.semi.spring.overwatch.model.service;

import java.util.List;
import org.springframework.stereotype.Service;
import com.semi.spring.overwatch.model.dao.OverwatchDao;
import com.semi.spring.overwatch.model.vo.HeroSkillsVO;
import com.semi.spring.overwatch.model.vo.HeroVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class OverwatchServiceImpl implements OverwatchService {

    private final OverwatchDao overdao;

    @Override
    public List<HeroVO> selectHeroList() {
        return overdao.selectHeroList();
    }

    @Override
    public HeroVO selectHero(int heroNo) {
        return overdao.selectHero(heroNo);
    }

    @Override
    public HeroSkillsVO selectHeroSkills(int heroNo) {
        return overdao.selectHeroSkills(heroNo);
    }
}