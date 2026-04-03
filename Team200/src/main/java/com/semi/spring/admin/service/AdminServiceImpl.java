package com.semi.spring.admin.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.semi.spring.admin.model.dao.AdminDao;
import com.semi.spring.board.model.vo.Inquiry;
import com.semi.spring.board.model.vo.Notice;
import com.semi.spring.board.model.vo.Patchnote;
import com.semi.spring.board.model.vo.Report;
import com.semi.spring.common.model.vo.PageInfo;
import com.semi.spring.member.model.vo.Member;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {

	private final AdminDao adminDao;
	
	@Override
	public int insertNotice(Notice notice) {
		return adminDao.insertNotice(notice);
	}

	@Override
	public int insertPatchnote(Patchnote patchnote) {
		return adminDao.insertPatchnote(patchnote);
	}

	@Override
	public Notice selectRecentNotice(Notice notice) {
		return adminDao.selectRecentNotice(notice);
	}

	@Override
	public Patchnote selectRecentPatchnote(Patchnote Patchnote) {
		return adminDao.selectRecentPatchnote(Patchnote);
	}

	@Override
	public List<Inquiry> selectInquiryList(PageInfo pi, Map<String, Object> filters) {
		int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
		RowBounds rowBounds = new RowBounds(offset, pi.getBoardLimit());
		
		return adminDao.selectInquiryList(filters, rowBounds);
	}

	@Override
	public List<Member> selectMemberList(PageInfo pi, Map<String, Object> filters) {
		// 몇 개를 건너뛰고(offset), 몇 개를 가져올지(limit) 계산
	    int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
	    RowBounds rowBounds = new RowBounds(offset, pi.getBoardLimit());
	    
	    // DAO 호출 시 rowBounds 전달
	    return adminDao.selectMemberList(filters, rowBounds);
	}
	
	@Override
	public List<Report> selectReportList(Map<String, Object> filters, PageInfo pi, String order) {
		int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
		RowBounds rowBounds = new RowBounds(offset, pi.getBoardLimit());
		
		return adminDao.selectReportList(filters, rowBounds);
	}

	@Override
	public int deleteMember(int userNo) {
		return adminDao.deleteMember(userNo);
	}

	@Transactional
	@Override
	public int updateUserWithdraw(int userNo, String withdraw) {
		return adminDao.updateUserWithdraw(userNo, withdraw);
	}

	@Transactional
	@Override
	public int insertAnswer(int boardNo, String answer) {
		return adminDao.insertAnswer(boardNo, answer);
	}

	@Override
	public int selectMemberListCount(Map<String, Object> filters) {
	    return adminDao.selectMemberListCount(filters);
	}

	@Override
	public int selectInquiryListCount(Map<String, Object> filters) {
		return adminDao.selectInquiryListCount(filters);
	}

	@Override
	public int getReportListCount(Map<String, Object> filters) {
		return adminDao.selectReportListCount(filters);
	}

	@Transactional
	@Override
	public int deleteContent(String type, int no) {
		int result = 0;
	    
	    if ("post".equals(type)) {
	        // 1. 게시글 삭제 (STATUS를 'N'으로 바꾸는 등 기존 삭제 로직 호출)
	        result = adminDao.deleteBoard(no); 
	        
	        // 2. 해당 게시글(boardNo)에 대한 모든 신고를 '처리 완료'로 업데이트
	        if (result > 0) {
	            adminDao.updateReportStatusByBoardNo(no);
	        }
	    } else {
	        // 1. 댓글 삭제
	        result = adminDao.deleteReply(no);
	        
	        // 2. 해당 댓글(replyNo)에 대한 모든 신고를 '처리 완료'로 업데이트
	        if (result > 0) {
	            adminDao.updateReportStatusByReplyNo(no);
	        }
	    }
	    
	    return result;
	}

	

}
