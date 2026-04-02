<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
                    <%-- 실제 데이터가 들어오는 곳 (예시 데이터) --%>
                    
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
										                <c:otherwise>[자유]</c:otherwise> 
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