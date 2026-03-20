<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/mypage/user_update/style.css">
	<script src="${pageContext.request.contextPath}/resources/mypage/user_update/script.js"></script>
    
    <title>LOG.GG - 개인정보 수정</title>
</head>
<body>

    <div class="profile-container">
        <h1>LOG.GG</h1>
        <h2>개인정보 수정</h2>
        
        <form action="#" method="POST">
            <div class="form-group">
                <div class="label-row"><span class="label">아이디</span></div>
                <input type="text" value="user_id_sample" readonly>
                <div class="notice">* 아이디는 변경할 수 없습니다.</div>
            </div>

            <div class="form-group">
                <div class="label-row">
                    <span class="label">현재 비밀번호 확인</span>
                    <button type="button" class="inner-btn">확인</button>
                </div>
                <input type="password" placeholder="정보 수정을 위해 현재 비번 입력">
            </div>

            <div class="form-group">
                <div class="label-row">
                    <span class="label">닉네임 변경</span>
                    <button type="button" class="inner-btn">중복확인</button>
                </div>
                <input type="text" placeholder="새로운 닉네임 입력">
            </div>

            <div class="form-group">
                <div class="label-row">
                    <span class="label">인증 이메일 변경</span>
                    <button type="button" class="inner-btn">인증</button>
                </div>
                <input type="email" value="old_email@log.gg">
            </div>

            <div class="form-group">
                <div class="label-row"><span class="label">새 비밀번호 (변경 시에만 입력)</span></div>
                <input type="password" placeholder="영문, 숫자 포함 8자 이상">
            </div>

            <button type="submit" class="btn-submit">정보 수정 완료</button>
        </form>
        
        <div class="withdraw-link">회원 탈퇴하기</div>
    </div>

</body>
</html>