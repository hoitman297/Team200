package com.semi.spring.admin.service;

import java.util.List;

import com.semi.spring.board.model.vo.Inquiry;
import com.semi.spring.board.model.vo.Notice;
import com.semi.spring.board.model.vo.Patchnote;
import com.semi.spring.member.model.vo.Member;

public interface AdminService {

	int insertNotice(Notice notice);
	
	int insertPatchnote(Patchnote patchnote);

	Notice selectRecentNotice(Notice notice);

	Patchnote selectRecentPatchnote(Patchnote recentPatchnote);

	List<Inquiry> selectInquiryList();

	List<Member> selectMemberList();

	int deleteMember(int userNo);

	int updateUserWithdraw(int userNo, String withdraw);

	
}
