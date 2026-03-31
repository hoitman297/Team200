package com.semi.spring.battleground.model.dao;

import com.semi.spring.battleground.model.vo.BagItemInfoVO;

public interface BattlegroundDao {

	int checkItemCount();

	void insertBagItem(BagItemInfoVO item);

}
