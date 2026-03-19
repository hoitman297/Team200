package com.semi.spring.member.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @NoArgsConstructor
@AllArgsConstructor @ToString
public class Member {
	private int userNo;
    private String userId;
    private String userPwd;
    private String userName;

    private Date enrollDate;
    private boolean withdraw;
    private String status;
    
    // private String userRole; 유저 권한까지 넣어야 되나?
}
