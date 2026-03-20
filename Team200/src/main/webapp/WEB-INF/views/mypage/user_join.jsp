<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/mypage/user_join/style.css">
	<script src="${pageContext.request.contextPath}/resources/mypage/user_join/script.js"></script>
	
    <title>LOG.GG - 회원가입</title>
</head>
<body>

    <div class="signup-container">
        <h1>LOG.GG</h1>
        <h2>회원정보를 입력해주세요</h2>
        
        <form action="#" method="POST">
            <div class="form-group">
                <div class="label-row"><span class="label">아이디 (중복체크)</span><button type="button" class="inner-btn">확인</button></div>
                <input type="text" placeholder="아이디 입력">
            </div>

            <div class="form-group">
                <div class="label-row"><span class="label">비밀번호</span></div>
                <input type="password" placeholder="영문, 숫자 포함 8자 이상">
            </div>

            <div class="form-group">
                <div class="label-row"><span class="label">비밀번호 확인</span></div>
                <input type="password" placeholder="비밀번호 재입력">
            </div>

            <div class="form-group">
                <div class="label-row"><span class="label">인증 이메일</span><button type="button" class="inner-btn">인증하기</button></div>
                <input type="email" placeholder="example@log.gg">
            </div>

            <div class="form-group">
                <div class="label-row"><span class="label">닉네임 (중복체크)</span><button type="button" class="inner-btn">확인</button></div>
                <input type="text" placeholder="사용할 닉네임">
            </div>


            <button type="submit" class="btn-submit">가입하기</button>
        </form>
    </div>

</body>
</html>