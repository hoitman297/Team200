package com.semi.spring.admin.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.semi.spring.board.model.vo.Inquiry;
import com.semi.spring.board.model.vo.Notice;
import com.semi.spring.board.model.vo.Patchnote;
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
	public List<Inquiry> selectInquiryList() {
		return session.selectList("admin.selectInquiryList");
	}

	@Override
	public List<Member> selectMemberList() {
		return session.selectList("admin.selectMemberList");
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

}
