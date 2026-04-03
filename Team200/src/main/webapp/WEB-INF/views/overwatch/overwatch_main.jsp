<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

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
                <a href="<c:url value ='/ow/main'/>"><div class="logo">LOG.GG</div></a>
                
                <c:set var="currentGameName" value="오버워치" />
                <c:set var="currentGameCode" value="overwatch" />
            </div>

            <div class="board-card">
                <div class="tab-menu">
                    <div class="tab-item active">실시간 인기글</div>
                    <a href="<c:url value='/ow/hero_main'/>"><div class="tab-item">영웅 정보</div></a>
                    <a href="<c:url value='/ow/box'/>"><div class="tab-item">상자 시뮬레이터</div></a>
                </div>
                <div class="tab-content">
                    <div class="board-row header-row">
                        <div class="col-likes">공감</div>
                        <div class="col-title">제목</div>
                        <div class="col-author">작성자</div>
                        <div class="col-date">날짜</div>
                    </div>
                    <%-- 실제 데이터가 들어오는 곳 --%>
                    
                    <c:choose>
                        <c:when test="${empty bestList}">
                            <div class="board-row" style="justify-content: center; color: #94a3b8;">
                                인기 게시글이 없습니다.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="best" items="${bestList}">
                                <div class="board-row">
                                    <div class="col-likes">
                                        ${best.likeCount}
                                    </div>
                                    
                                    <div class="col-title">
                                        <a href="<c:url value='/board/view?boardNo=${best.boardNo}' />" style="text-decoration: none; color: inherit; vertical-align: middle;">
                                             <span style="color: var(--accent-blue); font-weight: 800; margin-right: 6px; font-size: 14px;">
                                                <c:choose>
                                                    <c:when test="${best.categoryName == '자유게시판'}">[자유]</c:when>
                                                    <c:when test="${best.categoryName == '공략게시판'}">[공략]</c:when>
                                                    <c:when test="${best.categoryName == '갤러리'}">[갤러리]</c:when>
                                                    <c:otherwise>[기타]</c:otherwise> 
                                                </c:choose>
                                            </span>
                                            ${best.boardTitle}
                                            
                                            <c:if test="${best.replyCount > 0}">
                                                <span style="color: var(--accent-blue); font-weight: 800; font-size: 12px; margin-left: 4px;">[${best.replyCount}]</span>
                                            </c:if>
                                        </a>
                                    </div>
                                    
                                    <div class="col-author">
                                        ${best.userName}
                                    </div>
                                    
                                    <div class="col-date">
                                        <fmt:formatDate value="${best.postDate}" pattern="MM.dd"/>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    
                </div>
            </div>

            <div class="bottom-grid">
                <div class="grid-box" style="grid-column: 1 / -1;">
                    <%-- ✨ 갤러리 제목 --%>
                    <h4 style="margin: 0 0 15px 0;">갤러리</h4>
                    
                    <%-- ✨ 상자 영역과 더보기 버튼을 하나로 묶어 하단(flex-end)으로 나란히 정렬! --%>
                    <div style="display: flex; justify-content: space-between; align-items: flex-end;">
                        
                        <%-- ✨ flex: 1과 justify-content: center로 중앙 정렬, gap: 25px로 간격 조정 --%>
                        <div class="thumb-container" style="display: flex; gap: 25px; flex-wrap: wrap; flex: 1; justify-content: center;">
                            <c:forEach var="gal" items="${recentGallery}">
                                <a href="<c:url value='/board/view?boardNo=${gal.boardNo}'/>" style="text-decoration: none; display: block;">
                                    <div class="thumb" style="width: 140px; height: 140px; border-radius: 12px; overflow: hidden; background: #e2e8f0;">
                                        <c:choose>
                                            <c:when test="${not empty gal.thumbnail}">
                                                <img src="<c:url value='/resources/upload/board/${gal.thumbnail}'/>" alt="갤러리 썸네일" style="width: 100%; height: 100%; object-fit: cover; transition: transform 0.2s ease;">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="<c:url value='/resources/images/no_image.png'/>" alt="no-image" style="width: 100%; height: 100%; object-fit: contain; padding: 20px; box-sizing: border-box;">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </a>
                            </c:forEach>

                            <%-- ✨ 글이 4개가 안 될 경우 레이아웃 유지를 위한 빈 박스 채우기 (end="3"으로 4칸 확보!) --%>
                            <c:forEach begin="${empty recentGallery ? 0 : fn:length(recentGallery)}" end="3">
                                <div class="thumb" style="width: 140px; height: 140px; border-radius: 12px; background: #f1f5f9; display: flex; align-items: center; justify-content: center; color: #94a3b8; font-size: 13px; font-weight: 500; border: 1px dashed #cbd5e1; box-sizing: border-box;">
                                    비어있음
                                </div>
                            </c:forEach>
                        </div>

                        <%-- ✨ 우측 끝 빈 공간, 상자 맨 아랫줄에 안착한 더보기 버튼! (gameCode=OW 유지) --%>
                        <div style="padding-left: 15px; padding-bottom: 5px;">
                            <a href="<c:url value='/gallery/list?gameCode=OW'/>" style="font-size: 13px; color: #64748b; text-decoration: none; font-weight: 600;">더보기 &gt;</a>
                        </div>

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