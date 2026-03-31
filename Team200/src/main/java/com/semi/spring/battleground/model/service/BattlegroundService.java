package com.semi.spring.battleground.model.service;

import java.util.List;
import java.util.Map;
import com.semi.spring.battleground.model.vo.BagItemInfoVO;

public interface BattlegroundService {
    List<Map<String, Object>> selectCategoryList();
    List<BagItemInfoVO> selectAllItemList();
    List<BagItemInfoVO> selectItemListByCategory(int categoryNo);
}