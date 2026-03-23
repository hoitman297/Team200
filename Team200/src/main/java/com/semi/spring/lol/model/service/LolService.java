package com.semi.spring.lol.model.service;

import java.util.List;

import com.semi.spring.lol.model.vo.ChampionVO;

public interface LolService {

	List<ChampionVO> selectAllChampions();

}
