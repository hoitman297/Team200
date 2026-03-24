package com.semi.spring.lol.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;

import com.semi.spring.lol.model.vo.ChampionVO;
import com.semi.spring.lol.model.vo.LolItemVO;
import com.semi.spring.lol.model.vo.SkillVO;
import com.semi.spring.lol.model.vo.SkinVO;

public interface LolDao {
    List<ChampionVO> selectAllChampions();
    int insertChampion(ChampionVO vo);
    ChampionVO getChampDeta(int champNo);
    
    // --- [추가] 스킬과 스킨 저장 메서드 ---
    int insertChampionSkills(SkillVO skill);
    int insertChampionSkin(SkinVO skin);
	List<LolItemVO> selectAllItems();
	int insertItem(LolItemVO itemVO);
}