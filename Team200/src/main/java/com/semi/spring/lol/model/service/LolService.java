package com.semi.spring.lol.model.service;

import java.util.List;
import java.util.Map;

import com.semi.spring.common.model.vo.PageInfo;
import com.semi.spring.lol.model.vo.ChampionVO;
import com.semi.spring.lol.model.vo.LolItemVO;

public interface LolService {

	List<ChampionVO> selectAllChampions();

	ChampionVO getChampDeta(int champNo);


}
