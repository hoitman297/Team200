<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%-- 💖 [핵심 수정] 파일 최상단 변수 선언 💖 --%>
<c:set var="headerTitle" value="오버워치" />
<c:set var="currentGameName" value="오버워치" />
<c:set var="gameId" value="overwatch" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/overwatch/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">

<%-- 💖 공통 검색창 CSS (404 방지를 위해 경로 확인 필수!) 💖 --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/search/style.css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/overwatch/script.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>



<%-- 💖 공통 검색창 JS (ReferenceError 방지를 위해 수정된 script.js 사용) 💖 --%>
<script src="${pageContext.request.contextPath}/resources/search/script.js?v=1.3" defer></script>
<title>오버워치 영웅 정보 - LOG.GG</title>
</head>
<body>
    <%@ include file="../common/header.jsp"%>

    <div class="main-layout">
        <aside class="side-left">
            <%@ include file="../common/sidebar.jsp" %>
        </aside>

        <main class="content-area">
            <div class="top-row">
                <a href="<c:url value='/overwatch/main'/>" style="text-decoration: none;">
                    <div class="logo">LOG.GG</div>
                </a>
                
                <%--  영웅 모드 검색창 호출 💖 --%>
                <c:set var="searchType" value="hero" />
                <%@ include file="../common/search_bar.jsp" %>
            </div>

            <div class="board-card">
                <div class="hero-grid-container">
                    <div class="hero-grid">
                        <c:forEach var="hero" items="${heroList}">
                            <%-- 💡 검색 필터링 타겟: hero-item --%>
                            <a href="${pageContext.request.contextPath}/ow/hero_main/hero_info?heroNo=${hero.heroNo}" class="hero-item"> 
                                <img src="${hero.heroImg}" alt="${hero.heroName}" class="hero-img">
                                <%-- 💡 이름 비교 타겟: hero-name --%>
                                <h4 class="hero-name">${hero.heroName}</h4>
                                <p style="font-size: 12px; color: gray;">${hero.heroPosition}</p>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </main>

        <aside class="side-right">
            <div class="side-card" style="background: #e2e8f0; height: 300px;">
                <h3>최근 업데이트</h3>
                <div style="font-size: 13px; color: #475569; line-height: 1.6; margin-top: 10px;">
                    현재 서버에 영웅 데이터를 동기화 중입니다.<br> (최신 패치 버전 적용 완료)
                </div>
            </div>
        </aside>
    </div>

    <%@ include file="../common/footer.jsp"%>
</body>
</html>