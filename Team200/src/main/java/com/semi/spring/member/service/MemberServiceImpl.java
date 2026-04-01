package com.semi.spring.member.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.semi.spring.member.model.dao.MemberDao;
import com.semi.spring.member.model.vo.Member;
import com.semi.spring.security.model.vo.MemberExt;

@Service
public class MemberServiceImpl implements MemberService{

	@Autowired
	private BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	private MemberDao memberDao;
	
	@Override
	public int insertMember(Member member) {
		// 회원가입과 동시에 권한 추가
		int result = memberDao.insertMember(member);
		// mapper에서는 무조건 ROLE_USER 권한으로 설정
		
		// ROLE_ADMIN은 oracle Developer에서 변경
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
	public int pwCheck(String userPw) {
		return memberDao.pwCheck(userPw);
	}

	
	@Override
	public int nameCheck(String userName) {
		return memberDao.nameCheck(userName);
	}

	@Override
	public Member selectOne(String userId) {
		return memberDao.selectOne(userId);
	}

	@Override
	public int deleteMember(String userId) {
		return memberDao.deleteMember(userId);
	}

	@Override
	public Member findId(Member member) {
		return memberDao.selectId(member);
	}
	
	@Override
	public Member findPw(Member member) {
		return memberDao.selectPw(member);
	}
	
	@Override
	public int updateTempPw(String userId, String tempPw) {
		// 1. 임시 비밀번호를 암호화 (Security 사용 시)
	    String encodePw = passwordEncoder.encode(tempPw);
	    
	    // 2. 파라미터 세팅 (Member 객체에 담아서 전달)
	    Member member = new Member();
	    member.setUserId(userId);
	    member.setUserPw(encodePw); // 암호화된 비밀번호 세팅
		return memberDao.updateTempPw(member);
	}

	

}
