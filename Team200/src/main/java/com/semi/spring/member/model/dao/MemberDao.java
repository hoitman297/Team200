package com.semi.spring.member.model.dao;

import org.springframework.security.core.userdetails.UserDetails;

import com.semi.spring.member.model.vo.Member;
import com.semi.spring.security.model.vo.MemberExt;

public interface MemberDao {

	UserDetails loadUserByUsername(String username);

	int insertMember(Member member);

	void insertAuthority(Member member);

	int updateMember(MemberExt loginUser);

	Member loginMember(Member member);
	
	int idCheck(String userId);

	Member selectOne(String userId);

	int nameCheck(String userName);
}
