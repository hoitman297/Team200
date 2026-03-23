package com.semi.spring.lol.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.semi.spring.lol.model.dao.LolDao;
import com.semi.spring.lol.model.vo.ChampionVO;

@Service
public class LolServiceImpl implements LolService {
	@Autowired
	private LolDao lolDao;
	
	public List<ChampionVO> selectAllChampions() {
		// TODO Auto-generated method stub
		return lolDao.selectAllChampions();
	}

}
