<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- 💖 [핵심 수정] 사이드바와 헤더가 길을 잃지 않도록 맨 위에서 쾅쾅! 선언해 줍니다 💖 --%>
<c:set var="gameId" value="lol" />
<c:set var="currentGameName" value="리그 오브 레전드" />
<c:set var="headerTitle" value="리그 오브 레전드" />

<!DOCTYPE html>
<html lang="ko">
<head>    
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/lol/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    <%-- 🔍 검색창 드롭다운 디자인을 위해 추가 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/search/style_main.css">
    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/lol/script.js" defer></script>
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
    <%-- 🔍 모든 페이지 공통 검색 로직 --%>
    <script src="${pageContext.request.contextPath}/resources/search/script_main.js" defer></script>
    
    <title>리그 오브 레전드 - LOG.GG</title>
</head>

<body>
<%-- 변수를 맨 위로 올렸으니 여기선 부르기만 하면 됩니다 --%>
<%@ include file="../common/header.jsp" %>

<div class="main-layout">
    <aside class="side-left">
        <%-- ✨ 이제 사이드바가 gameId="lol"을 미리 읽어서 링크가 정상적으로 잡혀요! ✨ --%>
        <%@ include file="../common/sidebar.jsp" %>
    </aside>

    <main class="content-area">
        <div class="top-row">
            <a href="<c:url value='/lol/main'/>"><div class="logo">LOG.GG</div></a>
            
            <%-- 변수 선언부는 위로 올렸으니, 여기는 깔끔하게 공통 검색바만 삽입! --%>
            <%@ include file="../common/search_bar.jsp" %>
        </div>

        <div class="board-card">
            <div class="tab-menu">
                <div class="tab-item active">실시간 인기글</div>
                <a href="<c:url value ='/lol/hero_main'/>">
                    <div class="tab-item">챔피언정보</div>
                </a> 
                <a href="<c:url value ='/lol/rune'/>">
                    <div class="tab-item">룬</div>
                </a> 
                <a href="<c:url value ='/lol/item'/>">
                    <div class="tab-item">아이템</div>
                </a> 
                <a href="<c:url value ='/lol/box'/>">
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
                    <div class="col-title">롤 인게임 최근 소식 및 패치노트 안내</div>
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