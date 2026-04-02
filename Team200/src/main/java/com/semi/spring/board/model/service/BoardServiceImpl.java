package com.semi.spring.board.model.service;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.semi.spring.board.model.dao.BoardDao;
import com.semi.spring.board.model.vo.AttachFile;
import com.semi.spring.board.model.vo.Board;
import com.semi.spring.board.model.vo.BoardExt;
import com.semi.spring.board.model.vo.BoardLike;
import com.semi.spring.board.model.vo.BoardType;
import com.semi.spring.board.model.vo.GameInfoReply;
import com.semi.spring.board.model.vo.Inquiry;
import com.semi.spring.board.model.vo.Reply;
import com.semi.spring.board.model.vo.Report;
import com.semi.spring.common.model.vo.PageInfo;

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

	@Override
	@Transactional
	public int insertBoardLike(int boardNo, int userNo) {
	    BoardLike boardLike = new BoardLike(userNo, boardNo);
	    
	    // 1. 이미 공감을 눌렀는지 확인
	    int check = boardDao.checkBoardLike(boardLike);
	    
	    // 2. 이미 눌렀다면 -1을 돌려보내서 빠꾸(?) 먹이기
	    if (check > 0) {
	        return -1; 
	    }
	    
	    // 3. 안 눌렀다면 공감(INSERT) 추가!
	    boardDao.insertBoardLike(boardLike);
	    
	    // 4. 추가된 후의 최신 공감 갯수 리턴
	    return boardDao.selectBoardLikeCount(boardNo);
	}

	@Override
	public List<BoardExt> selectBestBoards(String gameCode) {
		return boardDao.selectBestBoards(gameCode);
	}

	@Override
	public List<Reply> selectReplyList(int boardNo) {
		return boardDao.selectReplyList(boardNo);
	}

	@Override
	public int insertReply(Reply reply) {
		return boardDao.insertReply(reply);
	}

	@Override
	public int deleteReply(Map<String, Object> paramMap) {
		return boardDao.deleteReply(paramMap);
	}

	

	@Override
	public int insertInquiry(Inquiry inquiry) {
		return boardDao.insertInquiry(inquiry);
	}

	@Override
	public int selectInquiryCount(Map<String, Object> paramMap) {
		return boardDao.selectInquiryCount(paramMap);
	}

	@Override
	public List<Inquiry> selectInquiryList(PageInfo pi, Map<String, Object> paramMap) {
		return boardDao.selectInquiryList(pi, paramMap);
	}

	@Transactional(rollbackFor = Exception.class)
	@Override
	public int updateBoard(Board board, List<MultipartFile> upFiles, List<Integer> deleteFileNos, String savePath) {
	    
	    int result = boardDao.updateBoard(board);

	    if (result > 0) {
	        
	        if (deleteFileNos != null && !deleteFileNos.isEmpty()) {
	            for (int fileNo : deleteFileNos) {
	                boardDao.deleteSelectedFile(fileNo);
	                
	            }
	        }

	        if (upFiles != null) {
	            List<AttachFile> attachFileList = new ArrayList<>();

	            for (int i = 0; i < upFiles.size(); i++) {
	                MultipartFile f = upFiles.get(i);
	                String originName = f.getOriginalFilename();

	                if (originName != null && !originName.equals("")) {
	                    String changeName = FileRename(originName); 

	                    AttachFile at = new AttachFile();
	                    at.setBoardNo(board.getBoardNo());
	                    at.setGameCode(board.getGameCode());
	                    at.setOriginName(originName);
	                    at.setChangeName(changeName);
	                    at.setFilePath("/resources/upload/board/");
	                    at.setFileSize(f.getSize());
	                    at.setFileExt(originName.substring(originName.lastIndexOf(".")));

	                    attachFileList.add(at);

	                    try {
	                        f.transferTo(new File(savePath + changeName));
	                    } catch (IOException e) {
	                        e.printStackTrace();
	                        throw new RuntimeException("수정 중 파일 저장 에러가 발생했습니다."); 
	                    }
	                }
	            }
	            
	            if (!attachFileList.isEmpty()) {
	                result = boardDao.insertAttachFileList(attachFileList);
	            }
	        }
	    }
	    return result;
	}

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteBoard(int boardNo) {
        return boardDao.deleteBoard(boardNo);
    }

	@Override
	public Inquiry selectInquiryDetail(int boardNo) {
		return boardDao.selectInquiryDetail(boardNo);
	}

	@Override
	public int deleteInquiry(int boardNo) {
	    return boardDao.deleteInquiry(boardNo);
	}

	@Override
	public int selectMyBoardsCount(Map<String, Object> paramMap) {
		return boardDao.selectMyBoardsCount(paramMap);
	}

	@Override
	public List<BoardExt> selectMyBoards(PageInfo pi, Map<String, Object> paramMap) {
		return boardDao.selectMyBoards(pi, paramMap);
	}

	@Override	
	public int selectMyRepliesCount(Map<String, Object> paramMap) {
		return boardDao.selectMyRepliesCount(paramMap);
	}

	@Override
	public List<Map<String, Object>> selectMyReplies(PageInfo pi, Map<String, Object> paramMap) {
		return boardDao.selectMyReplies(pi,paramMap);
	}

	@Override
	public int deleteMyReplies(Map<String, Object> paramMap) {
		return boardDao.deleteMyReplies(paramMap);
	}
	
	@Override
    public List<GameInfoReply> selectInfoReplies(Map<String, Object> paramMap) {
        return boardDao.selectInfoReplies(paramMap);
    }

    @Override
    public int insertInfoReply(GameInfoReply reply) {
        return boardDao.insertInfoReply(reply);
    }
    
    @Override
    public int deleteInfoReply(GameInfoReply reply) {
        return boardDao.deleteInfoReply(reply);
    }

    public int insertReport(Report report) {
        return boardDao.insertReport(report);
    }
    
    @Override
    public List<BoardExt> selectGalleryList(Map<String, Object> paramMap) {
        return boardDao.selectGalleryList(paramMap);
    }

    @Override
    public int selectGalleryCount(Map<String, Object> paramMap) {
        return boardDao.selectGalleryCount(paramMap);
    }
    
    @Override
    public int selectCategoryNoByName(Map<String, Object> paramMap) {
        return boardDao.selectCategoryNoByName(paramMap);
    }
}
