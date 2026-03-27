package com.semi.spring.admin.model.dao;

import com.semi.spring.board.model.vo.Notice;
import com.semi.spring.board.model.vo.Patchnote;

public interface AdminDao {

	int insertNotice(Notice notice);

	int insertPatchnote(Patchnote patchnote);

}
