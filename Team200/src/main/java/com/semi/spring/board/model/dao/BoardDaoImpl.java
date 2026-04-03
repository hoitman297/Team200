package com.semi.spring.board.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartFile;

import com.semi.spring.board.model.vo.AttachFile;
import com.semi.spring.board.model.vo.Board;
import com.semi.spring.board.model.vo.BoardExt;
import com.semi.spring.board.model.vo.BoardLike;
import com.semi.spring.board.model.vo.BoardType;
import com.semi.spring.board.model.vo.GameInfoReply;
import com.semi.spring.board.model.vo.Inquiry;
import com.semi.spring.board.model.vo.Patchnote;
import com.semi.spring.board.model.vo.Reply;
import com.semi.spring.board.model.vo.Report;
import com.semi.spring.common.model.vo.PageInfo;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
@RequiredArgsConstructor
public class BoardDaoImpl implements BoardDao {

	private final SqlSessionTemplate session;
	
//	@Override
//	public Map<String, Object> getBoardTypeMap(String boardType) {
//		return session.selectOne("board.getBoardTypeMap", "boardType");
//	}
	
//	@Override
//	public Map<String, Object> getCategoryTableMap(String gameCode) {
//		return session.selectOne("board.getCategoryTableMap", gameCode);
//	}
	
	@Override
	public List<Board> selectList(Map<String, Object> paramMap) {
		
		PageInfo pi = (PageInfo) paramMap.get("pi");
		int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
		int limit = pi.getBoardLimit();

		paramMap.put("offset",offset + 1);
		paramMap.put("limit", limit+offset);
		
		return session.selectList("board.selectList",paramMap);
	}
	
	@Override
	public int selectListCount(Map<String, Object> paramMap) {
		return session.selectOne("board.selectListCount", paramMap);
	}

	@Override
	public int insertBoard(Board board) {
		return session.insert("board.insertBoard",board);
	}

	@Override
	public int increaseCount(int boardNo) {
		return session.update("board.increaseCount",boardNo);
	}

	@Override
	public BoardExt selectBoard(int boardNo) {
		return session.selectOne("board.selectBoard",boardNo);
	}

	@Override
	public int insertBoard(Board board, List<MultipartFile> upFiles, String savePath) {
		return session.insert("board.insertBoard",board);
	}

	
	@Override
	public int insertAttachFileList(List<AttachFile> attachFileList) {
		return session.insert("board.insertAttachFileList", attachFileList);
	}

	@Override
	public BoardType getBoardTypeMap(String dbGameCode , String boardType) {
		Map<String, String> paramMap = new HashMap<>();
	    paramMap.put("gameCode", dbGameCode);
	    paramMap.put("boardType", boardType); 
	    
	    return session.selectOne("board.getBoardTypeMap", paramMap);
	}

	@Override
	public int checkBoardLike(BoardLike boardLike) {
		return session.selectOne("board.checkBoardLike", boardLike);
	}

	@Override
	public void insertBoardLike(BoardLike boardLike) {
		session.insert("board.insertBoardLike", boardLike);
	}

	@Override
	public int selectBoardLikeCount(int boardNo) {
		return session.selectOne("board.selectBoardLikeCount", boardNo);
	}

	@Override
	public List<BoardExt> selectBestBoards(String gameCode) {
	    return session.selectList("board.selectBestBoards",gameCode); 
	}

	@Override
	public List<Reply> selectReplyList(int boardNo) {
		return session.selectList("board.selectReplyList",boardNo);
	}

	@Override
	public int insertReply(Reply reply) {
		return session.insert("board.insertReply",reply);
	}
	
	@Override
	public int deleteReply(Map<String, Object> paramMap) {
	    return session.update("board.deleteReply", paramMap);
	}

	@Override
	public int selectCategoryNoByName(Map<String, Object> map) {
		return session.selectOne("board.selectCategoryNoByName", map);
	}

	@Override
	public int insertInquiry(Inquiry inquiry) {
		return session.insert("board.insertInquiry", inquiry);
	}

	@Override
	public int selectInquiryCount(Map<String, Object> paramMap) {
		return session.selectOne("board.selectInquiryCount", paramMap);
	}

	@Override
	public List<Inquiry> selectInquiryList(PageInfo pi, Map<String, Object> paramMap) {
		int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
	    RowBounds rowBounds = new RowBounds(offset, pi.getBoardLimit());
	    
	    return session.selectList("board.selectInquiryList", paramMap, rowBounds);
	}

	@Override
	public int deleteBoard(int boardNo) {
		return session.update("board.deleteBoard", boardNo);
	}

	@Override
	public int updateBoard(Board board) {
		return session.update("board.updateBoard", board);
	}

	@Override
	public void deleteSelectedFile(int fileNo) {
		session.delete("board.deleteSelectedFile", fileNo);
		
	}

	@Override
	public Inquiry selectInquiryDetail(int boardNo) {
		return session.selectOne("board.selectInquiryDetail", boardNo);
	}
	
	@Override
	public int deleteInquiry(int boardNo) {
	    return session.delete("board.deleteInquiry", boardNo);
	}

	@Override
	public int selectMyBoardsCount(Map<String, Object> paramMap) {
		return session.selectOne("board.selectMyBoardsCount", paramMap);
	}

	@Override
	public List<BoardExt> selectMyBoards(PageInfo pi, Map<String, Object> paramMap) {
	    // RowBounds를 쓰지 말고, paramMap에 직접 계산해서 넣습니다 (Oracle 방식)
	    int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit() + 1;
	    int limit = offset + pi.getBoardLimit() - 1;
	    
	    paramMap.put("offset", offset);
	    paramMap.put("limit", limit);
	    
	    // RowBounds를 제거하고 paramMap만 보냅니다.
	    return session.selectList("board.selectMyBoards", paramMap);
	}

	@Override
	public int selectMyRepliesCount(Map<String, Object> paramMap) {
		return session.selectOne("board.selectMyRepliesCount", paramMap);
	}

	@Override
	public List<Map<String, Object>> selectMyReplies(PageInfo pi, Map<String, Object> paramMap) {
	    int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit() + 1;
	    int limit = offset + pi.getBoardLimit() - 1;
	    
	    paramMap.put("offset", offset);
	    paramMap.put("limit", limit);
	    
	    return session.selectList("board.selectMyReplies", paramMap);
	}
	
	@Override
	public int deleteMyReplies(Map<String, Object> paramMap) {
	    return session.update("board.deleteMyReplies", paramMap);
	}
	
	@Override
    public List<GameInfoReply> selectInfoReplies(Map<String, Object> paramMap) {
        return session.selectList("board.selectInfoReplies", paramMap);
    }

    @Override
    public int insertInfoReply(GameInfoReply reply) {
        return session.insert("board.insertInfoReply", reply);
    }
    
    @Override
    public int deleteInfoReply(GameInfoReply reply) {
        return session.update("board.deleteInfoReply", reply);
    }
    
    public int insertReport(Report report) {
        return session.insert("board.insertReport", report);
    }
    
    @Override
    public List<BoardExt> selectGalleryList(Map<String, Object> paramMap) {
        return session.selectList("board.selectGalleryList", paramMap);
    }

    @Override
    public int selectGalleryCount(Map<String, Object> paramMap) {
        return session.selectOne("board.selectGalleryCount", paramMap);
    }
    
    @Override
    public List<BoardExt> selectRecentGallery(String gameCode) {
        return session.selectList("board.selectRecentGallery", gameCode);
    }
    
    @Override
    public int selectPatchnoteCount(Map<String, Object> paramMap) {
        return session.selectOne("board.selectPatchnoteCount", paramMap);
    }

    @Override
    public List<BoardExt> selectPatchnoteList(Map<String, Object> paramMap) {
        return session.selectList("board.selectPatchnoteList", paramMap);
    }
    
    @Override
    public BoardExt selectPatchnoteDetail(int boardNo) {
        return session.selectOne("board.selectPatchnoteDetail", boardNo);
    }
    
    @Override
    public int updateOfficialReadCount(Map<String, Object> paramMap) {
        return session.update("board.updateOfficialReadCount", paramMap);
    }

	@Override
	public List<BoardExt> selectNoticeList(Map<String, Object> paramMap) {
		 return session.selectList("board.selectNoticeList", paramMap);
	}

	@Override
	public BoardExt selectNoticeDetail(int boardNo) {
		return session.selectOne("board.selectNoticeDetail", boardNo);
	}

	@Override
	public int selectNoticeCount(Map<String, Object> paramMap) {
		return session.selectOne("board.selectNoticeCount", paramMap);
	}
	
	@Override
    public List<BoardExt> selectMainPatchNotes() {
        return session.selectList("board.selectMainPatchNotes");
    }

    @Override
    public List<BoardExt> selectMainNotices() {
        return session.selectList("board.selectMainNotices");
    }
    
    @Override
    public List<BoardExt> selectPatchnoteListForSide(Map<String, Object> paramMap) {
        return session.selectList("board.selectPatchnoteList", paramMap);
    }
}

