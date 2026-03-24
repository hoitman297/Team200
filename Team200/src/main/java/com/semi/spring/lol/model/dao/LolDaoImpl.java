package com.semi.spring.lol.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.semi.spring.lol.model.vo.ChampionVO;

@Repository
public class LolDaoImpl implements LolDao {
	
	@Autowired
	private SqlSessionTemplate session;

	@Override
	public List<ChampionVO> selectAllChampions() {
		// TODO Auto-generated method stub
		return session.selectList("lolMapper.selectAllChampions");

//		
//		mapper 파일 제작 시 코드
//
//		<mapper namespace="lolMapper">
//
//			<select id="selectAllChampions" resultType="com.semi.spring.lol.model.vo.ChampionVO">
//				SELECT 
//					CHAMP_NAME AS name,
//					CHAMP_ENG_NAME AS engName
//				FROM CHAMPIONS
//				ORDER BY CHAMP_NAME ASC
//			</select>
//
//		</mapper>
	}

	@Override
	public int insertChampion(ChampionVO vo) {
		return session.insert("lolMapper.insertChampion", vo);
	}

	@Override
	public ChampionVO getChampDeta(int champNo) {
		// TODO Auto-generated method stub
		return session.selectOne("lolMapper.getChampDeta",champNo);
	}

}
