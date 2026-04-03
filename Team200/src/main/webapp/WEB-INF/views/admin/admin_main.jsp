<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/admin/admin_main/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    <script src="${pageContext.request.contextPath}/resources/admin/admin_main/script.js"></script>
	<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
	
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <title>LOG.GG - 통합 게임 플랫폼</title>
    <%@ include file="../common/header.jsp"%>
</head>
<body>

    <div class="container">
        <aside class="main-side">
            <div class="side-card">
                <h3>게임별 패치노트 <button class="btn-mini">
                 <a href="<c:url value = '/admin/patchnote'/>">패치노트 등록</a></button></h3>
                <ul class="patch-list">
                    <li><strong>오버워치</strong><span>2026.03.05</span></li>
                    <li><strong>배틀그라운드</strong><span>2026.02.05</span></li>
                    <li><strong>리그 오브 레전드</strong><span>2026.01.15</span></li>
                </ul>
            </div>
        </aside>

        <main class="main-content">
            <div class="brand-search">
                <h1>LOG.GG</h1>
            </div>

            <div class="content-card">
                <nav class="tab-nav">
                    <button class="tab-btn active" onclick="openTab(event, 'tab-board')">관리자 페이지</button>
                    <button class="tab-btn" onclick="location.href='<c:url value='/admin/user_management' />'">회원관리</button>
                    <button class="tab-btn" onclick="location.href='<c:url value='/admin/inquiry' />'">고객지원</button>
                    <button class="tab-btn" onclick="location.href='<c:url value='/admin/user_report'/>'">신고내역</button>
                </nav>

                <div id="tab-board" class="tab-pane active">
                    <table class="board-table">
                      
                            	<p style="font-weight:700">관리자 전용 페이지입니다. 각 탭 별로 누를시 이동합니다</p> 
                               
                    </table>
                    
                    <div style="margin:40px 0 15px 0; display: flex; justify-content: space-between; align-items: flex-end;">
                    </div>
                    <div class="footer-visual">
                    </div>
                </div>

        </main>

        <aside class="main-side">
            <div class="side-card" style="background:#cbd5e1">
                <h3 style="border-color: #475569;">공지사항 
                <button class="btn-mini" style="background:#fff">
                <a href="<c:url value = '/admin/notice'/>">공지 등록</a></button>
                </h3>
                <ul class="patch-list">
                    <li style="border-color: #94a3b8;">${title}<span>${postDate}</span></li>
                    <li style="border-color: #94a3b8;">웹사이트 업데이트 내역<span>2026.03.01</span></li>
                </ul>
            </div>
        </aside>
    </div>
    
   

    <footer>© 2026 LOG.GG 게임 커뮤니티 플랫폼. 모든 권리 보유.</footer>
</body>
</html>