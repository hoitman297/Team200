<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 1. 변수 설정: 주소창의 game 값을 읽어옴 --%>
<c:set var="currentGame" value="${empty param.game ? 'all' : param.game}" />

<%-- 2. 사이드바용 gameId 설정: 전체(all)일 때는 기본으로 'battleground'를 보여주도록 세팅 --%>
<c:set var="gameId" value="${currentGame == 'all' ? 'battleground' : currentGame}" />

<%-- 3. 푸터나 헤더에 표시할 게임 이름 매칭 (선택사항) --%>
<c:set var="displayGameName">
    <c:choose>
        <c:when test="${currentGame == 'battleground'}">배틀그라운드</c:when>
        <c:when test="${currentGame == 'lol'}">리그 오브 레전드</c:when>
        <c:when test="${currentGame == 'overwatch'}">오버워치</c:when>
        <c:otherwise>전체</c:otherwise>
    </c:choose>
</c:set>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/gallery/gallery_list/style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
    <title>LOG.GG - 갤러리</title>
</head>
<body>
    <%-- 헤더에 게임 이름 전달 --%>
    <c:set var="headerTitle" value="${displayGameName}" />
    <%@ include file="../common/header.jsp" %>

    <div class="main-layout">
        <aside class="side-left">
            <%-- 여기서 sidebar.jsp는 위에서 정한 gameId를 사용함 --%>
            <%@ include file="../common/sidebar.jsp" %>
        </aside>

        <main class="content-area">
            <a href="<c:url value ='/'/>"><div class="logo">LOG.GG</div></a>

            <div class="gallery-container">
                <div class="gallery-header">
                    <h2>갤러리</h2>
                    <a href="<c:url value='/gallery/write' />"><button class="btn-write">글쓰기</button></a>
                </div>

                <%-- 게임 분류 필터 탭 --%>
                <div class="gallery-filter">
                    <a href="<c:url value='/gallery/list?game=all' />" class="filter-btn ${currentGame == 'all' ? 'active' : ''}">전체</a>
                    <a href="<c:url value='/gallery/list?game=battleground' />" class="filter-btn ${currentGame == 'battleground' ? 'active' : ''}">배틀그라운드</a>
                    <a href="<c:url value='/gallery/list?game=lol' />" class="filter-btn ${currentGame == 'lol' ? 'active' : ''}">리그 오브 레전드</a>
                    <a href="<c:url value='/gallery/list?game=overwatch' />" class="filter-btn ${currentGame == 'overwatch' ? 'active' : ''}">오버워치</a>
                </div>

                <div class="gallery-grid">
                    <%-- 아이템 리스트 (기존과 동일) --%>
                    <div class="gallery-item">...</div>
                    <div class="gallery-item">...</div>
                    <div class="gallery-item">...</div>
                </div>

                <div class="pagination">
                    <a href="#" class="page-link">&lt;</a>
                    <a href="#" class="page-link active">1</a>
                    <a href="#" class="page-link">&gt;</a>
                </div>
            </div>
        </main>

        <aside class="side-right">
            <div class="side-card" style="background: #cbd5e1; min-height: 200px;">
                <h3 style="border-bottom: none;">갤러리 안내</h3>
                <p style="font-size: 14px; color: #475569; line-height: 1.7; font-weight: 500;">
                    멋진 스크린샷과 영상을 공유해주세요.<br><br>
                    추천을 많이 받은 게시물은 메인 화면에 노출될 수 있습니다.
                </p>
            </div>
        </aside>
    </div>

    <footer>© 2026 LOG.GG ${displayGameName} 서비스. 모든 권리 보유.</footer>
</body>
</html>