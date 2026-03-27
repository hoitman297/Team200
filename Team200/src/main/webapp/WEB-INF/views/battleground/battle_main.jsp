<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/battleground/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    <%-- 🔍 검색창 드롭다운 디자인용 CSS 추가 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/search/style_main.css">
    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/battleground/script.js" defer></script>
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
    <%-- 🔍 통합 검색 로직 JS 추가 --%>
    <script src="${pageContext.request.contextPath}/resources/search/script_main.js" defer></script>
    
    <title>배틀그라운드 - LOG.GG</title>
</head>

<body>
    <c:set var="headerTitle" value="배틀그라운드" />
    <%@ include file="../common/header.jsp" %>

    <div class="main-layout">
        <aside class="side-left">
            <%@ include file="../common/sidebar.jsp" %>
        </aside>

        <main class="content-area">
            <div class="top-row">
                <a href="<c:url value='/battleground/main'/>"><div class="logo">LOG.GG</div></a>
                
                <%-- 💖 검색바 설정: 배그 전용 데이터 세팅 💖 --%>
                <c:set var="currentGameName" value="배틀그라운드" />
                <c:set var="gameId" value="battleground" />
                
                <%-- 💖 공통 검색바 삽입 💖 --%>
                <%@ include file="../common/search_bar.jsp" %>
            </div>

            <div class="board-card">
                <div class="tab-menu">
                    <div class="tab-item active">실시간 인기글</div>
                    <a href="<c:url value='/battleground/item'/>">
                        <div class="tab-item">아이템</div>
                    </a>
                    <a href="<c:url value='/battleground/map'/>">
                        <div class="tab-item">지도</div>
                    </a>
                    <a href="<c:url value='/battleground/box'/>">
                        <div class="tab-item">상자 시뮬레이터</div>
                    </a>
                </div>
                <div class="tab-content">
                    <div class="board-row header-row">
                        <div class="col-likes">공감</div>
                        <div class="col-title">제목</div>
                        <div class="col-author">작성자</div>
                        <div class="col-date">날짜</div>
                    </div>
                    <div class="board-row">
                        <div class="col-likes">150</div>
                        <div class="col-title">배틀그라운드 인게임 최근 소식 및 패치노트 안내</div>
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

    <%@ include file="../common/footer.jsp" %>
</body>
</html>