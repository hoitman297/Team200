package com.semi.spring.admin.service;

import com.semi.spring.board.model.vo.Notice;
import com.semi.spring.board.model.vo.Patchnote;

public interface AdminService {

	int insertNotice(Notice notice);
	
	int insertPatchnote(Patchnote patchnote);

	
}
