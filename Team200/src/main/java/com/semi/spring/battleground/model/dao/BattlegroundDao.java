package com.semi.spring.battleground.model.dao;

import java.util.List;
import java.util.Map;

import com.semi.spring.battleground.model.vo.BagItemInfoVO;

public interface BattlegroundDao {

	int checkItemCount();

	void insertBagItem(BagItemInfoVO item);

	List<Map<String, Object>> selectCategoryList();

	List<BagItemInfoVO> selectAllItemList();

	List<BagItemInfoVO> selectItemListByCategory(int categoryNo);

}
