package com.semi.spring.battleground.model.service;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import com.semi.spring.battleground.model.dao.BattlegroundDao;
import com.semi.spring.battleground.model.vo.BagItemInfoVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BattlegroundServiceImpl implements BattlegroundService {

    private final BattlegroundDao dao;

    @Override
    public List<Map<String, Object>> selectCategoryList() {
        return dao.selectCategoryList();
    }

    @Override
    public List<BagItemInfoVO> selectAllItemList() {
        return dao.selectAllItemList();
    }

    @Override
    public List<BagItemInfoVO> selectItemListByCategory(int categoryNo) {
        return dao.selectItemListByCategory(categoryNo);
    }
}