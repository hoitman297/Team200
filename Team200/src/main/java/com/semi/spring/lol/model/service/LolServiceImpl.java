package com.semi.spring.lol.model.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.semi.spring.common.model.vo.PageInfo;
import com.semi.spring.lol.model.dao.LolDao;
import com.semi.spring.lol.model.vo.ChampionVO;
import com.semi.spring.lol.model.vo.LolItemVO;
import com.semi.spring.lol.model.vo.RuneVO;
import com.semi.spring.lol.model.vo.TalentVO;

@Service
public class LolServiceImpl implements LolService {
	@Autowired
	private LolDao lolDao;
	
	public List<ChampionVO> selectAllChampions() {
		// TODO Auto-generated method stub
		return lolDao.selectAllChampions();
	}

	@Override
	public ChampionVO getChampDeta(int champNo) {
		// TODO Auto-generated method stub
		return lolDao.getChampDeta(champNo);
	}

	@Override
	public List<RuneVO> selectAllRunes() {
		// TODO Auto-generated method stub
		return lolDao.selectAllRunes();
	}

	@Override
	public List<TalentVO> selectTalentsByRune(int runeNo) {
		// TODO Auto-generated method stub
		return lolDao.selectTalentsByRune(runeNo);
	}
	
	
}
