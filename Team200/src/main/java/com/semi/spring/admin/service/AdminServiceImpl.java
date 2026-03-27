package com.semi.spring.admin.service;

import org.springframework.stereotype.Service;

import com.semi.spring.admin.model.dao.AdminDao;
import com.semi.spring.board.model.dao.BoardDao;
import com.semi.spring.board.model.vo.Notice;
import com.semi.spring.board.model.vo.Patchnote;

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

}
