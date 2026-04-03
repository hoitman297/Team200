package com.semi.spring.admin.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.semi.spring.board.model.vo.Inquiry;
import com.semi.spring.board.model.vo.Notice;
import com.semi.spring.board.model.vo.Patchnote;
import com.semi.spring.board.model.vo.Report;
import com.semi.spring.member.model.vo.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
@RequiredArgsConstructor
@Transactional
public class AdminDaoImpl implements AdminDao{
	
	private final SqlSessionTemplate session;

	@Override
	public int insertNotice(Notice notice) {
		return session.insert("admin.insertNotice",notice);
	}

	@Override
	public int insertPatchnote(Patchnote patchnote) {
		return session.insert("admin.insertPatchnote",patchnote);
	}

	@Override
	public Notice selectRecentNotice(Notice notice) {
		return session.selectOne("admin.selectRecentNotice",notice);
	}

	@Override
	public Patchnote selectRecentPatchnote(Patchnote patchnote) {
		return session.selectOne("admin.selectRecentPatchnote",patchnote);
	}

	@Override
	public List<Inquiry> selectInquiryList(Map<String, Object> filters, RowBounds rowBounds) {
		return session.selectList("admin.selectInquiryList", filters , rowBounds);
	}

	public List<Member> selectMemberList(Map<String, Object> filters, RowBounds rowBounds) {
	    return session.selectList("admin.selectMemberList", filters, rowBounds);
	}
	
	@Override
	public List<Report> selectReportList(Map<String, Object> filters, RowBounds rowBounds) {
		return session.selectList("admin.selectReportList", filters, rowBounds);
	}
	
	@Override
	public int deleteMember(int userNo) {
		return session.delete("admin.deleteMember", userNo);
	}

	@Override
	public int updateUserWithdraw(int userNo, String withdraw) {
		Map<String, Object> map = new HashMap<>();
		map.put("userNo", userNo);    // 매퍼의 #{userNo}와 매칭
	    map.put("withdraw", withdraw); // 매퍼의 #{withdraw}와 매칭
	    
		return session.update("admin.updateUserWithdraw", map);
	}

	@Transactional
	@Override
	public int insertAnswer(int boardNo, String answer) {
		Map<String , Object> map = new HashMap<>();
		map.put("boardNo", boardNo);
		map.put("answer", answer);
		
		return session.update("admin.insertAnswer", map);
	}
	
	@Override
	public int selectMemberListCount(Map<String, Object> filters) {
		return session.selectOne("admin.selectMemberListCount", filters);
	}

	@Override
	public int selectInquiryListCount(Map<String, Object> filters) {
		return session.selectOne("admin.selectInquiryListCount",filters);
	}
	
	@Override
	public int selectReportListCount(Map<String, Object> filters) {
		return session.selectOne("admin.selectReportListCount", filters);
	}

	@Override
    public int deleteContent(String type, int no) {
        if ("post".equals(type)) {
            // 게시글 삭제 성공 시 관련 신고 상태도 업데이트
            int result = deleteBoard(no);
            if (result > 0) updateReportStatusByBoardNo(no);
            return result;
        } else {
            // 댓글 삭제 성공 시 관련 신고 상태도 업데이트
            int result = deleteReply(no);
            if (result > 0) updateReportStatusByReplyNo(no);
            return result;
        }
    }

	// 2. 게시글 상태 변경 (삭제 처리)
    @Override
    public int deleteBoard(int no) {
        // board-mapper.xml 등에 정의된 id 호출
        return session.update("admin.deleteBoard", no);
    }

    // 3. 댓글 상태 변경 (삭제 처리)
    @Override
    public int deleteReply(int no) {
        // reply-mapper.xml 등에 정의된 id 호출
        return session.update("admin.deleteReply", no);
    }

    // 4. 게시글 관련 신고들 처리 완료로 업데이트
    @Override
    public void updateReportStatusByBoardNo(int no) {
    	session.update("admin.updateReportStatusByBoardNo", no);
    }

    // 5. 댓글 관련 신고들 처리 완료로 업데이트
    @Override
    public void updateReportStatusByReplyNo(int no) {
    	session.update("admin.updateReportStatusByReplyNo", no);
    }

	
	
	

}
