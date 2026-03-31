package com.semi.spring.battleground.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.semi.spring.battleground.model.vo.BagItemInfoVO;

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

	public List<Map<String, Object>> selectCategoryList() {
        return session.selectList("battlegroundMapper.selectCategoryList");
    }

    public List<BagItemInfoVO> selectAllItemList() {
        return session.selectList("battlegroundMapper.selectAllItemList");
    }

    public List<BagItemInfoVO> selectItemListByCategory(int categoryNo) {
        return session.selectList("battlegroundMapper.selectItemListByCategory", categoryNo);
    }
}
