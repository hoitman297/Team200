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
		System.out.println("loginMember : MemberDaoImpl");
		return session.selectOne("member.loginMember", member);
	}

	@Override
	public int idCheck(String userId) {
		return session.selectOne("member.idCheck",userId);
	}
	
	@Override
	public int nameCheck(String userName) {
		return session.selectOne("member.nameCheck",userName);
	}

	@Override
	public Member selectOne(String userId) {
		return session.selectOne("member.selectOne",userId);
	}
	
	@Override
	public int pwCheck(String userPw) {
		return session.selectOne("member.pwCheck",userPw);
	}

	@Override
	public UserDetails loadUserByUsername(String userName) {
		return session.selectOne("security.loadUserByUsername", userName);
	}

	@Override
	public int deleteMember(String userId) {
		return session.delete("member.deleteMember", userId);
	}


}
