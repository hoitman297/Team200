<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/member/user_mypage/style.css">
	<script src="${pageContext.request.contextPath}/resources/member/user_mypage/script.js"></script>
    
    <title>마이페이지 - Desktop Dashboard</title>
</head>
<body>

    <div class="dashboard-container">
		<aside class="sidebar">
			<div class="profile-img"
				onclick="document.getElementById('profileInput').click()">
				<img id="profilePreview"
					src="${pageContext.request.contextPath}${not empty secUser.profilePath ? secUser.profilePath : '/resources/img/default_profile.png'}"
					alt="프로필">
				<div class="overlay">변경</div>
			</div>
			<input type="file" id="profileInput" accept="image/*"
				style="display: none;" onchange="uploadProfile(event)">

			<div class="user-info">
				<sec:authentication property="principal" var="secUser" />
				<h1>${secUser.userName}</h1>
				<p>
					일반 회원<br>${secUser.email}</p>
			</div>

			<a href="<c:url value = '/member/login' />"><button
					class="logout-btn" onclick="msg('로그아웃')">로그아웃</button></a>

			<div class="logo-bottom">LOG.GG</div>
		</aside>

		<main class="main-content">
            <section class="card">
                <h2>⚙️ <span style="color: #475569;">계정 설정</span></h2>
                <div class="menu-grid">
                	<a href="<c:url value = '/member/update' />">
                    <div class="menu-item" onclick="msg('회원 정보 및 비밀번호 수정')">
                        <strong>회원 정보 수정</strong>
                        <span>이메일, 연락처 및 비밀번호를 변경합니다.</span>
                    </div>
                    </a>
                </div>
            </section>

            <section class="card">
                <h2>📝 <span style="color: #475569;">커뮤니티 활동</span></h2>
                <div class="menu-grid">
                	<a href="<c:url value = '/member/activity' />">
                    <div class="menu-item" onclick="msg('게시글 조회')">
                        <strong>작성한 게시글 / 댓글 조회</strong>
                        <span style="color: #ff5454; font-weight: bold;">내가 쓴 글 총 12개</span> 
                    </div>
                    
                    </a>
                    <a href="<c:url value = '/member/comment' />">
                    <div class="menu-item" onclick="msg('삭제 관리')">
                        <strong>수정 및 삭제 관리</strong>
                        <span>일괄 삭제 기능을 제공합니다.</span>
                    </div>
                    </a>
                    
                </div>
            </section>

            <section class="card">
                <h2>⚠️ <span style="color: #475569;">기타 설정</span></h2>
                <a href="<c:url value = '/member/delete_p' />">
                <div class="menu-grid">
                    <div class="menu-item withdraw-item" onclick="confirmWithdrawal()">
                        <strong>회원 탈퇴</strong>
                        <span>계정을 삭제하며 모든 데이터를 파기합니다.</span>
                    </div>
                </div>
                </a>
            </section>
        </main>
    </div>

</body>
</html>