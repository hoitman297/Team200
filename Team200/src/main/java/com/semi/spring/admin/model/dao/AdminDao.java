package com.semi.spring.admin.model.dao;

import java.util.List;

import com.semi.spring.board.model.vo.Inquiry;
import com.semi.spring.board.model.vo.Notice;
import com.semi.spring.board.model.vo.Patchnote;
import com.semi.spring.member.model.vo.Member;

public interface AdminDao {

	int insertNotice(Notice notice);

	int insertPatchnote(Patchnote patchnote);

	Notice selectRecentNotice(Notice notice);

	Patchnote selectRecentPatchnote(Patchnote patchnote);

	List<Inquiry> selectInquiryList();

	List<Member> selectMemberList();

	int deleteMember(int userNo);

	int updateUserWithdraw(int userNo, String withdraw);

}
