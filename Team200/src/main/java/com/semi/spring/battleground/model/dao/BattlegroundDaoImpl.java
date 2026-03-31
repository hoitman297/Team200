package com.semi.spring.battleground.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.semi.spring.battleground.model.vo.BagItemInfoVO;
import com.semi.spring.overwatch.model.dao.OverwatchDaoImpl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Repository
@RequiredArgsConstructor
public class BattlegroundDaoImpl implements BattlegroundDao {

	private final SqlSessionTemplate session;

	@Override
	public int checkItemCount() {
		return session.selectOne("battlegroundMapper.checkItemCount");
	}

	@Override
	public void insertBagItem(BagItemInfoVO item) {
		session.insert("battlegroundMapper.insertBagItem", item);
	}

}
