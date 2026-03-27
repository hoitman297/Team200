<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 💖 [핵심 수정] 파일 최상단에서 변수를 미리 선언합니다! 💖 --%>
<c:set var="headerTitle" value="오버워치" />
<c:set var="currentGameName" value="오버워치" />
<c:set var="gameId" value="overwatch" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/overwatch/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    
    <%-- 🔍 검색창 전용 스타일 (공통 파일로 경로 통일) --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/search/style.css">
    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/overwatch/script.js" defer></script>
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
    
    <%-- 🔍 공통 검색 스크립트 (방금 우리가 수정한 script.js) --%>
    <%-- 기존 script.js 경로를 아래처럼 버전(v=1.1)을 붙여서 수정 --%>
	<script src="${pageContext.request.contextPath}/resources/search/script.js" defer></script>

    <title>오버워치 - LOG.GG</title>
</head>

<body>
    <%-- 헤더 --%>
    <%@ include file="../common/header.jsp"%>

    <div class="main-layout">
        <aside class="side-left">
            <%-- 사이드바 --%>
            <%@ include file="../common/sidebar.jsp" %>
        </aside>

        <main class="content-area">
            <div class="top-row">
                <a href="<c:url value ='/overwatch/main'/>"><div class="logo">LOG.GG</div></a>
                
                <%-- 💖 통합 검색(global) 모드로 검색창 호출! 💖 --%>
                <c:set var="searchType" value="global" />
                <%@ include file="../common/search_bar.jsp" %>
            </div>

            <div class="board-card">
                <div class="tab-menu">
                    <div class="tab-item active">실시간 인기글</div>
                    <a href="<c:url value='/overwatch/hero_main'/>"><div class="tab-item">영웅 정보</div></a>
                    <a href="<c:url value='/overwatch/box'/>"><div class="tab-item">상자 시뮬레이터</div></a>
                </div>
                <div class="tab-content">
                    <div class="board-row header-row">
                        <div class="col-likes">공감</div>
                        <div class="col-title">제목</div>
                        <div class="col-author">작성자</div>
                        <div class="col-date">날짜</div>
                    </div>
                    <%-- 실제 데이터가 들어오는 곳 (예시 데이터) --%>
                    <div class="board-row">
                        <div class="col-likes">150</div>
                        <div class="col-title">오버워치 인게임 최근 소식 및 패치노트 안내</div>
                        <div class="col-author">관리자</div>
                        <div class="col-date">03.01</div>
                    </div>
                </div>
            </div>

            <div class="bottom-grid">
                <div class="grid-box">
                    <h4>갤러리</h4>
                    <div class="thumb-container">
                        <div class="thumb"></div>
                        <div class="thumb"></div>
                    </div>
                </div>
                <div class="grid-box">
                    <h4>인게임 소식</h4>
                    <div class="thumb-container">
                        <div class="thumb"></div>
                        <div class="thumb"></div>
                    </div>
                </div>
            </div>
        </main>

        <aside class="sidebar-right">
            <h3>최근 업데이트</h3>
            <div style="font-size: 14px; color: #475569; line-height: 1.8;">
                최신 업데이트 내용을 확인하세요.
            </div>
        </aside>
    </div>
    
    <%@ include file="../common/footer.jsp"%>
</body>
</html>