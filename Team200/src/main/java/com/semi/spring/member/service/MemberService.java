package com.semi.spring.member.service;

import com.semi.spring.member.model.vo.Member;
import com.semi.spring.security.model.vo.MemberExt;

public interface MemberService {

	int insertMember(Member member);

	int updateMember(MemberExt loginUser);

	Member loginMember(Member member);

	int idCheck(String userId);

	Member selectOne(String userId);

}
