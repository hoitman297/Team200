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
		memberDao.insertAuthority(member);
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

}
