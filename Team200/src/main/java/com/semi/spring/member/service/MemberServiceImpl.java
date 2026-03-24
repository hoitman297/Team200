package com.semi.spring.member.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.semi.spring.member.model.dao.MemberDao;
import com.semi.spring.member.model.vo.Member;
import com.semi.spring.security.model.vo.MemberExt;

@Service
public class MemberServiceImpl implements MemberService{

	@Autowired
	private MemberDao memberDao;
	
	@Override
	public int insertMember(Member member) {
		// 회원가입과 동시에 권한 추가
		int result = memberDao.insertMember(member);
		// mapper에서는 무조건 ROLE_USER 권한으로 설정
		
		// ROLE_ADMIN은 oracle Developer에서 변경
		// memberDao.insertAuthority(member); 
		// 따로 Dao 메서드를 만들어서 권한만 설정하면 오류 우려되므로 일단 주석처리
		return result;
	}

	@Override
	public int updateMember(MemberExt loginUser) {
		return memberDao.updateMember(loginUser);
	}

	@Override
	public Member loginMember(Member member) {
		return memberDao.loginMember(member);
	}

	@Override
	public int idCheck(String userId) {
		return memberDao.idCheck(userId);
	}
	
	@Override
	public int nameCheck(String userName) {
		return memberDao.nameCheck(userName);
	}

	@Override
	public Member selectOne(String userId) {
		return memberDao.selectOne(userId);
	}


}
