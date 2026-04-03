package com.semi.spring.admin.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;

import com.semi.spring.board.model.vo.Inquiry;
import com.semi.spring.board.model.vo.Notice;
import com.semi.spring.board.model.vo.Patchnote;
import com.semi.spring.board.model.vo.Report;
import com.semi.spring.member.model.vo.Member;

public interface AdminDao {

	int insertNotice(Notice notice);

	int insertPatchnote(Patchnote patchnote);

	Notice selectRecentNotice(Notice notice);

	Patchnote selectRecentPatchnote(Patchnote patchnote);

	List<Inquiry> selectInquiryList(Map<String, Object> filters, RowBounds rowBounds);

	List<Member> selectMemberList(Map<String, Object> filters, RowBounds rowbounds);
	
	List<Report> selectReportList(Map<String, Object> filters, RowBounds rowBounds);

	int deleteMember(int userNo);

	int updateUserWithdraw(int userNo, String withdraw);

	int insertAnswer(int boardNo, String answer);

	int selectMemberListCount(Map<String, Object> filters);

	int selectInquiryListCount(Map<String, Object> filters);

	int selectReportListCount(Map<String, Object> filters);

	int deleteContent(String type, int no);

	int deleteBoard(int no);

	int deleteReply(int no);

	void updateReportStatusByBoardNo(int no);

	void updateReportStatusByReplyNo(int no);

	

	

}
