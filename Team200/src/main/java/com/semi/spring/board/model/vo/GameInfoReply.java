package com.semi.spring.board.model.vo;

import java.sql.Date;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GameInfoReply {
    private int infoReplyNo;    // 댓글 번호
    private int userNo;         // 작성자 회원번호
    private String gameCode;    // 게임 코드 (LOL, OW)
    private int targetNo;       // 챔피언 번호(CHAMP_NO) 또는 영웅 번호(HERO_NO)
    private String replyContent;// 댓글 내용
    private Date replyDate;     // 작성일
    private String status;      // 상태(Y/N)
    
    private String userName;    // 닉네임
    private int parentReplyNo;
    private boolean admin; 
    
}
