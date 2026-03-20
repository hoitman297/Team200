package com.semi.spring.lol.model.dao;

import java.util.List;

import com.semi.spring.lol.model.vo.ChampionVO;

public interface LolDao {

	List<ChampionVO> selectAllChampions();

}
