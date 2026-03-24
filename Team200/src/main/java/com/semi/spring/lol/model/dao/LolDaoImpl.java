package com.semi.spring.lol.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.semi.spring.lol.model.vo.ChampionVO;
import com.semi.spring.lol.model.vo.LolItemVO;
import com.semi.spring.lol.model.vo.RuneVO;
import com.semi.spring.lol.model.vo.SkillVO;
import com.semi.spring.lol.model.vo.SkinVO;
import com.semi.spring.lol.model.vo.TalentVO;

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
	
	// 기존 코드 유지하고 아래 두 메서드만 추가해 주세요!
	@Override
	public int insertChampionSkills(SkillVO skill) {
	    return session.insert("lolMapper.insertChampionSkills", skill);
	}

	@Override
	public int insertChampionSkin(SkinVO skin) {
	    return session.insert("lolMapper.insertChampionSkin", skin);
	}

	@Override
	public List<LolItemVO> selectAllItems() {
		// TODO Auto-generated method stub
		return session.selectList("lolMapper.selectAllItems");
	}

	@Override
	public int insertItem(LolItemVO itemVO) {
		return session.insert("lolMapper.insertItem",itemVO);
		
	}

	@Override
	public int insertRune(RuneVO rune) {
		// TODO Auto-generated method stub
		return session.insert("lolMapper.insertRune",rune);
	}

	@Override
	public int insertTalent(TalentVO talent) {
		// TODO Auto-generated method stub
		return session.insert("lolMapper.insertTalent",talent);
	}

	@Override
	public List<RuneVO> selectAllRunes() {
	    return session.selectList("lolMapper.selectAllRunes");
	}

	@Override
	public List<TalentVO> selectTalentsByRune(int runeNo) {
		// TODO Auto-generated method stub
		return session.selectList("lolMapper.selectTalentsByRune",runeNo);
	}
}
