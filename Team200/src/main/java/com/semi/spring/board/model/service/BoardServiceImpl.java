package com.semi.spring.board.model.service;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.semi.spring.board.model.dao.BoardDao;
import com.semi.spring.board.model.vo.AttachFile;
import com.semi.spring.board.model.vo.Board;
import com.semi.spring.board.model.vo.BoardExt;
import com.semi.spring.board.model.vo.BoardType;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {

	private final BoardDao boardDao;
	
//	@Override
//	public Map<String, Object> getCategoryTableMap(String gameCode) {
//		System.out.println("gameCode : " + gameCode);
//		return boardDao.getCategoryTableMap(gameCode);
//	}
	
	@Override
	public int selectListCount(Map<String, Object> paramMap) {
		return boardDao.selectListCount(paramMap);
	}

	@Override
	public List<Board> selectList(Map<String, Object> paramMap) {
		return boardDao.selectList(paramMap);
	}

	@Override
	public int increaseCount(int boardNo) {
		return boardDao.increaseCount(boardNo);
	}

	@Override
	public BoardExt selectBoard(int boardNo) {
		return boardDao.selectBoard(boardNo);
	}

	@Transactional(rollbackFor = Exception.class)
	@Override
	public int insertBoard(Board board, List<MultipartFile> upFiles, String savePath) {

		int result = boardDao.insertBoard(board);

		if (result > 0 && upFiles != null) {
			List<AttachFile> attachFileList = new ArrayList<>();

			for (int i = 0; i < upFiles.size(); i++) {
				MultipartFile f = upFiles.get(i);
				
				String originName = f.getOriginalFilename();

				if (!f.getOriginalFilename().equals("")) {

					String changeName = FileRename(f.getOriginalFilename()); // 파일명 변경 유틸

					AttachFile at = new AttachFile();
					at.setBoardNo(board.getBoardNo());
					at.setGameCode(board.getGameCode());
					at.setOriginName(f.getOriginalFilename());
					at.setChangeName(changeName);
					at.setFilePath("/resources/upload/board/");
					at.setFileSize(f.getSize());

					at.setFileExt(originName.substring(originName.lastIndexOf(".")));

					attachFileList.add(at);

					try {
						f.transferTo(new File(savePath + changeName));
					} catch (IOException e) {
						e.printStackTrace();
						throw new RuntimeException("파일 저장 중 에러가 발생했습니다.");
					}
				}

			}
			if (!attachFileList.isEmpty()) {
				result = boardDao.insertAttachFileList(attachFileList);
			}
		}
		return result;
	}

	public String FileRename(String originName) {
		String ext = originName.substring(originName.lastIndexOf("."));
		String time = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
		int ran = (int) (Math.random() * 90000) + 10000;
		return time + "_" + ran + ext;
	}

	@Override
	public BoardType getBoardTypeMap(String dbGameCode, String boardType) {
		return boardDao.getBoardTypeMap(dbGameCode ,boardType);
	}

	


}
