<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/member/user_idpw/style.css">
	<script src="${pageContext.request.contextPath}/resources/member/user_idpw/script.js"></script>

    <title>LOG.GG - 아이디/비밀번호 찾기</title>
</head>
<body>

    <div class="find-card">
        <div class="logo">LOG.GG</div>

        <div class="tab-group">
            <div id="tab-id" class="tab active" onclick="switchTab('id')">아이디 찾기</div>
            <div id="tab-pw" class="tab" onclick="switchTab('pw')">비밀번호 찾기</div>
        </div>

        <div id="section-id" class="find-section active">
            <p class="info-text">가입 시 등록한 이름과 이메일을 입력하세요.</p>
            <div class="form-group">
                <label>이름</label>
                <input type="text" placeholder="성함을 입력하세요">
            </div>
            <div class="form-group">
                <label>이메일</label>
                <input type="email" placeholder="이메일 입력">
            </div>
            <button class="btn-main">아이디 찾기</button>
        </div>

        <div id="section-pw" class="find-section">
            <p class="info-text">비밀번호 재설정을 위해 정보를 입력하세요.</p>
            <div class="form-group">
                <label>아이디</label>
                <input type="text" placeholder="아이디를 입력하세요">
            </div>
            <div class="form-group">
                <label>이름</label>
                <input type="text" placeholder="성함을 입력하세요">
            </div>
            <div class="form-group">
                <label>가입 이메일</label>
                <input type="email" placeholder="이메일 입력">
            </div>
            <button class="btn-main">비밀번호 찾기</button>
        </div>

        <div class="footer-link">
            <a href="<c:url value = '/member/login' />">로그인 화면으로 돌아가기</a>
        </div>
    </div>
</body>
</html>