package com.semi.spring.admin.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.semi.spring.board.model.vo.Notice;
import com.semi.spring.board.model.vo.Patchnote;

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

}
