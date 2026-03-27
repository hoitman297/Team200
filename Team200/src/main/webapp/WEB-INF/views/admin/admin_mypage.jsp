<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/admin/admin_mypage/style.css"> 
<%--     <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css"> --%>
	<script src="${pageContext.request.contextPath}/resources/admin/admin_mypage/script.js"></script>

    <title>마이페이지 - Desktop Dashboard</title>
</head>
<body>

    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="profile-img" onclick="changeImage()">ADMIN</div>
            
            <div class="user-info">
                <h1>관리자</h1>
                <button class="logout-btn" onclick="logoutConfirm()">로그아웃</button>
            </div>

            <div class="logo-bottom">LOG.GG</div>
        </aside>

        <main class="main-content">
            <section class="card">
                <h2>⚙️ <span style="color: #475569;">회원 관리</span></h2>
                <div class="menu-grid">
                    <div class="menu-item" onclick="msg('회원 정보 및 비밀번호 수정')">
                        <a href="<c:url value = '/admin/user_management' />"><strong>회원 관리</strong></a>
                        <span>사용자 계정 수정 및 계정 정지</span>
                    </div>
                </div>
            </section>

            <section class="card">
                <h2>📝 <span style="color: #475569;">게시물 관리</span></h2>
                <div class="menu-grid">
                    <div class="menu-item" onclick="msg('게시글 조회')">
                        <strong>공지사항 / 패치노트</strong>
                        <span>공지사항 / 패치노트 수정 및 삭제</span> 
                    </div>
                    <div class="menu-item" onclick="msg('삭제 관리')">
                        <strong>회원 게시물 / 댓글 관리</strong>
                        <span>사용자 게시물 / 댓글 수정 및 삭제</span>
                    </div>
                </div>
            </section>

            <section class="card">
                <h2>💬 <span style="color: #475569;">커뮤니티 관리</span></h2>
                <div class="menu-grid">
                    <div class="menu-item" onclick="msg('문의 내역')">
                        <strong>문의 내역</strong>
                        <span>문의사항 관리</span>
                    </div>
                    <div class="menu-item" onclick="msg('신고 내역')">
                        <strong>신고 내역</strong>
                        <span>사용자 및 게시물 신고 관리</span>
                    </div>
                </div>
            </section>
        </main>
    </div>
</body>
</html>