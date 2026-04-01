package com.semi.spring.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.semi.spring.admin.model.dao.AdminDao;
import com.semi.spring.board.model.vo.Inquiry;
import com.semi.spring.board.model.vo.Notice;
import com.semi.spring.board.model.vo.Patchnote;
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
	public List<Inquiry> selectInquiryList() {
		return adminDao.selectInquiryList();
	}

	@Override
	public List<Member> selectMemberList() {
		return adminDao.selectMemberList();
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

}
