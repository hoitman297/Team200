package com.semi.spring.admin.service;

import java.util.List;
import java.util.Map;

import com.semi.spring.board.model.vo.Inquiry;
import com.semi.spring.board.model.vo.Notice;
import com.semi.spring.board.model.vo.Patchnote;
import com.semi.spring.board.model.vo.Report;
import com.semi.spring.common.model.vo.PageInfo;
import com.semi.spring.member.model.vo.Member;

public interface AdminService {

	int insertNotice(Notice notice);
	
	int insertPatchnote(Patchnote patchnote);

	Notice selectRecentNotice(Notice notice);

	Patchnote selectRecentPatchnote(Patchnote recentPatchnote);

	List<Inquiry> selectInquiryList(PageInfo pi, Map<String, Object> filters);

	List<Member> selectMemberList(PageInfo pi, Map<String, Object> filters);
	
	List<Report> selectReportList(Map<String, Object> filters, PageInfo pi, String order);

	int deleteMember(int userNo);

	int updateUserWithdraw(int userNo, String withdraw);

	int insertAnswer(int boardNo, String answer);

	int selectMemberListCount(Map<String, Object> filters);

	int selectInquiryListCount(Map<String, Object> filters);

	int getReportListCount(Map<String, Object> filters);

	int deleteContent(String type, int no);
	
}
