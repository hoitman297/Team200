<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<%-- 1. 게임 이름, 경로 및 말머리(태그) 설정 --%>
<c:choose>
    <c:when test="${board.gameCode == 'BG'}">
        <c:set var="gameName" value="배틀그라운드"/>
        <c:set var="safeGameId" value="battleground"/>
        <c:set var="gameTag" value="[배그]"/>
        <c:set var="tagColor" value="#ffb142"/>
    </c:when>
    <c:when test="${board.gameCode == 'OW'}">
        <c:set var="gameName" value="오버워치"/>
        <c:set var="safeGameId" value="overwatch"/>
        <c:set var="gameTag" value="[OW]"/>
        <c:set var="tagColor" value="#ff9f43"/>
    </c:when>
    <c:otherwise>
        <c:set var="gameName" value="리그 오브 레전드"/>
        <c:set var="safeGameId" value="lol"/>
        <c:set var="gameTag" value="[LOL]"/>
        <c:set var="tagColor" value="#00a8ff"/>
    </c:otherwise>
</c:choose>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <title>LOG.GG - ${gameTag} ${board.boardTitle}</title>

    <%-- ✨ 기존 게시판과 동일한 CSS 파일 사용! --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/board_view/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
</head>
<body>  
    <c:set var="headerTitle" value="${gameName}" />
    <%@ include file="../common/header.jsp" %>

    <div class="main-layout">
        <%-- ✨ 사이드바 (올려주신 코드 형태 유지) --%>
        <aside class="side-left">
            <div class="side-card">
                <h3>카테고리</h3>
                <a href="${pageContext.request.contextPath}/gallery/list" class="menu-link" style="text-decoration: none; color: inherit;">
                    <div class="menu-item">갤러리</div>
                </a>
                <div class="menu-item-group">
                    <div class="menu-item">게시판</div>
                    <div class="sub-menu-container"> 
                        <div class="sub-item" onclick="location.href='<c:url value="/board/free_${safeGameId}"/>'">자유게시판</div>
                        <div class="sub-item" onclick="location.href='<c:url value="/board/strategy_${safeGameId}"/>'">공략게시판</div>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/board/inquiry" class="menu-link" style="text-decoration: none; color: inherit;">
                    <div class="menu-item">고객지원</div>
                </a>
            </div>
        </aside>

        <main class="content-area">
            <%-- ✨ 통합 메인으로 가는 로고 --%>
            <a href="<c:url value='/' />" style="text-decoration: none; color: inherit;">
                <div class="logo">LOG.GG</div>
            </a>

            <article class="view-container">
                <div class="post-header">
					<div class="post-category">${board.categoryName}</div>
                    
                    <%-- ✨ 제목 앞에 게임 태그 붙여주기 --%>
                    <h1 class="post-title">
                        <span style="color: ${tagColor}; margin-right: 5px;">${gameTag}</span>
                        ${board.boardTitle}
                    </h1>
                    
                    <div class="post-info">
                        <span>글쓴이: <b>${board.userName}</b></span>
                        <span>날짜: <b><fmt:formatDate value="${board.postDate}" pattern="yyyy-MM-dd HH:mm"/></b></span>
                        <span>조회수 : <b>${board.readCount}</b></span>
                    </div>
                </div>

                <%-- ✨ 본문 출력 (이미지 첨부 로직 그대로 유지!) --%>
                <div class="post-body" style="white-space: pre-wrap; line-height: 1.6;">${board.boardContent}
                    <c:if test="${not empty board.fileList}">
                        <div class="post-images" style="margin-top: 20px; text-align: center;">
                            <c:forEach var="file" items="${board.fileList}">
                                <img src="<c:url value='/resources/upload/board/${file.changeName}'/>" 
                                     alt="첨부 이미지" 
                                     style="max-width: 100%; height: auto; margin-bottom: 15px; border-radius: 8px;">
                            </c:forEach>
                        </div>
                    </c:if>
                </div>

                <%-- ✨ 액션 버튼 (공감, 신고 빼고 오직 "목록으로"만 남김) --%>
                <div class="post-action" style="justify-content: center;">
                    <%-- 목록으로 돌아갈 때 파라미터가 'all'인지 특정 게임인지 알기 위해 history.back() 사용 권장 --%>
                    <button class="btn-action" onclick="history.back();" style="width: 150px;">목록으로</button>
                </div>

                <%-- 댓글 영역 (comment-section) 통째로 삭제됨! --%>
            </article>
        </main>
        
        <aside class="side-right"></aside>
    </div>
    
    <footer>© 2026 LOG.GG ${gameName} 서비스. 모든 권리 보유.</footer>

    <%-- 복잡한 AJAX, 시큐리티 스크립트 모두 삭제됨! (읽기 전용이므로 필요 없음) --%>
</body>
</html>