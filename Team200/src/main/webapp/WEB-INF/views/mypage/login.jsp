<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/mypage/login/style.css">
	<script src="${pageContext.request.contextPath}/resources/mypage/login/script.js"></script>
	
	<title>로그인</title>
</head>
<body>
    <div class="login-card">
        <h1>LOG.GG</h1>
        <div class="input-group">
            <label>아이디</label>
            <input type="text" placeholder="아이디를 입력하세요">
        </div>
        <div class="input-group">
            <label>비밀번호</label>
            <input type="password" placeholder="비밀번호를 입력하세요">
        </div>
        <button class="login-btn">로그인</button>
        <div class="links">비밀번호 찾기 | 회원가입</div>
    </div>
</body>
</html>