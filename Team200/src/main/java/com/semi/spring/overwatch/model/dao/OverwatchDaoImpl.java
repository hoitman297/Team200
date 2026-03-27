package com.semi.spring.overwatch.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.semi.spring.overwatch.model.vo.HeroSkillsVO;
import com.semi.spring.overwatch.model.vo.HeroSkinVO;
import com.semi.spring.overwatch.model.vo.HeroVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
@RequiredArgsConstructor
public class OverwatchDaoImpl implements OverwatchDao {

	private final SqlSessionTemplate session;

	// Mapper XML의 namespace와 정확히 일치해야 합니다. (오타 방지용 상수 선언)
	private final String NAMESPACE = "overwatchMapper.";

	@Override
	public int checkHeroCount() {
		// 단일 결과값이므로 selectOne 사용
		return session.selectOne(NAMESPACE + "checkHeroCount");
	}

	@Override
	public void insertHero(HeroVO hero) {
		// DB에 영웅 데이터 삽입
		session.insert(NAMESPACE + "insertHero", hero);
	}

	@Override
	public void insertHeroSkills(HeroSkillsVO skills) {
		// DB에 스킬 데이터 삽입
		session.insert(NAMESPACE + "insertHeroSkills", skills);
	}

	@Override
	public List<HeroVO> selectHeroList() {
		// 여러 행을 가져오므로 selectList 사용
		return session.selectList(NAMESPACE + "selectHeroList");
	}

	@Override
	public HeroVO selectHero(int heroNo) {
		// 특정 영웅 1명의 정보만 가져오므로 selectOne 사용
		return session.selectOne(NAMESPACE + "selectHero", heroNo);
	}

	@Override
	public HeroSkillsVO selectHeroSkills(int heroNo) {
		// 특정 영웅 1명의 스킬 정보만 가져오므로 selectOne 사용
		return session.selectOne(NAMESPACE + "selectHeroSkills", heroNo);
	}

	@Override
	public void insertHeroSkin(HeroSkinVO skin) {
		session.insert(NAMESPACE + "insertHeroSkin", skin);
	}
}