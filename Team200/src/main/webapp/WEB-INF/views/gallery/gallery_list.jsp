<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 1. 변수 설정: 주소창의 gameCode 값을 읽어옴 (컨트롤러 파라미터명과 일치) --%>
<c:set var="currentGame" value="${empty param.gameCode ? 'all' : param.gameCode}" />

<%-- 2. 사이드바용 gameId 설정: 전체(all)일 때는 기본으로 'battleground'를 보여주도록 세팅 --%>
<c:set var="gameId" value="${currentGame == 'all' ? 'battleground' : currentGame}" />

<%-- 3. 푸터나 헤더에 표시할 게임 이름 매칭 --%>
<c:set var="displayGameName">
    <c:choose>
        <c:when test="${currentGame == 'BG'}">배틀그라운드</c:when>
        <c:when test="${currentGame == 'LOL'}">리그 오브 레전드</c:when>
        <c:when test="${currentGame == 'OW'}">오버워치</c:when>
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
            <%@ include file="../common/sidebar.jsp" %>
        </aside>

        <main class="content-area">
            <a href="<c:url value ='/'/>" style="text-decoration:none;"><div class="logo">LOG.GG</div></a>

            <div class="gallery-container">
                <div class="gallery-header">
                    <h2>갤러리</h2>
                    <%-- 글쓰기 버튼 (현재 보고 있는 탭의 게임 코드를 물고 감) --%>
                    <a href="<c:url value='/gallery/write?gameCode=${currentGame}' />">
                        <button class="btn-write">글쓰기</button>
                    </a>
                </div>

                <%-- 게임 분류 필터 탭 --%>
                <div class="gallery-filter">
                    <a href="<c:url value='/gallery/list?gameCode=all' />" class="filter-btn ${currentGame == 'all' ? 'active' : ''}">전체</a>
                    <a href="<c:url value='/gallery/list?gameCode=BG' />" class="filter-btn ${currentGame == 'BG' ? 'active' : ''}">배틀그라운드</a>
                    <a href="<c:url value='/gallery/list?gameCode=LOL' />" class="filter-btn ${currentGame == 'LOL' ? 'active' : ''}">리그 오브 레전드</a>
                    <a href="<c:url value='/gallery/list?gameCode=OW' />" class="filter-btn ${currentGame == 'OW' ? 'active' : ''}">오버워치</a>
                </div>

                <%-- 갤러리 바둑판 영역 --%>
                <div class="gallery-grid">
                    <c:choose>
                        <c:when test="${empty list}">
                            <div style="grid-column: 1 / -1; text-align: center; padding: 60px; color: #94a3b8;">
                                아직 등록된 사진이 없습니다. 멋진 사진을 가장 먼저 공유해주세요! 📸
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="board" items="${list}">
                                <%-- 카드 클릭 시 상세 페이지로 이동 --%>
                                <a href="<c:url value='/board/view?boardNo=${board.boardNo}'/>" class="gallery-item" style="text-decoration: none; color: inherit; display: block;">
                                    
                                    <%-- 썸네일 --%>
                                    <div class="thumb-box" style="width: 100%; height: 200px; overflow: hidden; background: #f1f5f9; border-radius: 8px 8px 0 0;">
                                        <c:choose>
                                            <c:when test="${not empty board.thumbnail}">
                                                <img src="<c:url value='/resources/upload/board/${board.thumbnail}'/>" alt="썸네일" style="width: 100%; height: 100%; object-fit: cover;">
                                            </c:when>
                                            <c:otherwise>
                                                <%-- 이미지가 없는 글일 경우의 기본 썸네일 --%>
                                                <img src="<c:url value='/resources/images/no_image.png'/>" alt="no-image" style="width: 100%; height: 100%; object-fit: contain; padding: 20px;">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <%-- 글 정보 (제목, 작성자, 하트/댓글 수) --%>
                                    <div class="info-box" style="padding: 15px; border: 1px solid #e2e8f0; border-top: none; border-radius: 0 0 8px 8px; background: white;">
                                        <div style="font-weight: bold; font-size: 15px; color: #1e293b; margin-bottom: 8px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                            ${board.boardTitle}
                                        </div>
                                        <div style="display: flex; justify-content: space-between; align-items: center; font-size: 13px; color: #64748b;">
                                            <span>${board.userName}</span>
                                            <span>👍 ${board.likeCount} | 💬 ${board.replyCount}</span>
                                        </div>
                                    </div>
                                    
                                </a>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- 페이징 영역 --%>
                <div class="pagination" style="margin-top: 30px; text-align: center;">
                    <%-- 이전 버튼 (1페이지가 아닐 때만 노출) --%>
                    <c:if test="${pi.currentPage > 1}">
                        <a href="<c:url value='/gallery/list?gameCode=${currentGame}&cp=${pi.currentPage - 1}'/>" class="page-link">&lt;</a>
                    </c:if>

                    <%-- 페이지 번호 반복 --%>
                    <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
                        <a href="<c:url value='/gallery/list?gameCode=${currentGame}&cp=${p}'/>" class="page-link ${pi.currentPage == p ? 'active' : ''}">${p}</a>
                    </c:forEach>

                    <%-- 다음 버튼 (마지막 페이지가 아닐 때만 노출) --%>
                    <c:if test="${pi.currentPage < pi.maxPage}">
                        <a href="<c:url value='/gallery/list?gameCode=${currentGame}&cp=${pi.currentPage + 1}'/>" class="page-link">&gt;</a>
                    </c:if>
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