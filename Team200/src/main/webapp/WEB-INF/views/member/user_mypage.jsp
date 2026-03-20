<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
            <div class="profile-img" onclick="changeImage()">프로필 변경</div>
            <div class="user-info">
                <h1>닉네임</h1>
                <p>일반 회원<br>email@naver.com</p>
            </div>
            
            <button class="logout-btn" onclick="msg('로그아웃')">로그아웃</button>
            
            <div class="logo-bottom">LOG.GG</div>
        </aside>

        <main class="main-content">
            <section class="card">
                <h2>⚙️ <span style="color: #475569;">계정 설정</span></h2>
                <div class="menu-grid">
                    <div class="menu-item" onclick="msg('회원 정보 및 비밀번호 수정')">
                        <a href="<c:url value = '/member/update' />"><strong>회원 정보 수정</strong></a>
                        <span>이메일, 연락처 및 비밀번호를 변경합니다.</span>
                    </div>
                </div>
            </section>

            <section class="card">
                <h2>📝 <span style="color: #475569;">커뮤니티 활동</span></h2>
                <div class="menu-grid">
                    <div class="menu-item" onclick="msg('게시글 조회')">
                        <strong>작성한 게시글 / 댓글 조회</strong>
                        <span style="color: #ff5454; font-weight: bold;">내가 쓴 글 총 12개</span> 
                    </div>
                    <div class="menu-item" onclick="msg('삭제 관리')">
                        <strong>수정 및 삭제 관리</strong>
                        <span>일괄 삭제 기능을 제공합니다.</span>
                    </div>
                </div>
            </section>

            <section class="card">
                <h2>⚠️ <span style="color: #475569;">기타 설정</span></h2>
                <a href="../마이페이지/회원탈퇴1.html">
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