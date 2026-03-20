package com.semi.spring.member.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Repository;

import com.semi.spring.member.model.vo.Member;
import com.semi.spring.security.model.vo.MemberExt;

@Repository
public class MemberDaoImpl implements MemberDao{

	@Autowired
	private SqlSessionTemplate session;
	
	@Override
	public UserDetails loadUserByUsername(String username) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int insertMember(Member member) {
		return session.insert("member.insertMember",member);
	}

	@Override
	public void insertAuthority(Member member) {
		session.insert("member.insertAuthority",member);
	}

	@Override
	public int updateMember(MemberExt loginUser) {
		return session.update("member.updateMember",loginUser);
	}

	@Override
	public Member loginMember(Member member) {
		return session.selectOne("member.loginMember", member);
	}

	@Override
	public int idCheck(String userId) {
		return session.selectOne("member.idCheck",userId);
	}

	@Override
	public Member selectOne(String userId) {
		return session.selectOne("member.selectOne",userId);
	}

}
