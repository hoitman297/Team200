<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- 게임 이름 및 경로 설정 --%>
<c:set var="safeGameId" value="${fn:toLowerCase(board.gameCode)}" />
<c:choose>
    <c:when test="${board.gameCode == 'BG'}">
        <c:set var="gameName" value="배틀그라운드"/>
        <c:set var="safeGameId" value="battleground"/>
    </c:when>
    <c:when test="${board.gameCode == 'OW'}">
        <c:set var="gameName" value="오버워치"/>
        <c:set var="safeGameId" value="overwatch"/>
    </c:when>
    <c:otherwise>
        <c:set var="gameName" value="리그 오브 레전드"/>
        <c:set var="safeGameId" value="lol"/>
    </c:otherwise>
</c:choose>
<c:set var="boardTypePath" value="${fn:contains(board.categoryName, '공략') ? 'strategy' : 'free'}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <sec:csrfMetaTags />
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    
    <title>LOG.GG - ${board.boardTitle}</title>

    <%-- CSS 파일 불러오기 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/board_view/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    
    <%-- jQuery 불러오기 --%>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

    <%-- 🌟 외부 JS 파일에서 사용할 전역 변수 선언 (JSP에서만 EL태그가 동작하기 때문) --%>
    <script>
        const contextPath = "${pageContext.request.contextPath}";
        const currentBoardNo = ${board.boardNo};
    </script>
    
    <%-- 분리된 외부 JS 파일 불러오기 --%>
    <script src="${pageContext.request.contextPath}/resources/board/board_view/script.js" defer></script>
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
</head>
<body>  
    <c:set var="headerTitle" value="게시판" />
    <%@ include file="../common/header.jsp" %>

    <div class="main-layout">
        <aside class="side-left">
            <div class="side-card">
                <h3>카테고리</h3>
                <div class="menu-item" onclick="location.href='gallery.html'">갤러리</div>
                <div class="menu-item-group">
                    <div class="menu-item">게시판</div>
                    <div class="sub-menu-container"> 
                        <div class="sub-item ${boardTypePath == 'free' ? 'active' : ''}" onclick="location.href='<c:url value="/board/free_${safeGameId}"/>'">자유게시판</div>
                        <div class="sub-item ${boardTypePath == 'strategy' ? 'active' : ''}" onclick="location.href='<c:url value="/board/strategy_${safeGameId}"/>'">공략게시판</div>
                    </div>
                </div>
                <div class="menu-item" onclick="location.href='qna-list.html'">고객지원</div>
            </div>
        </aside>

        <main class="content-area">
            <a href="<c:url value='/' />" style="text-decoration: none; color: inherit;">
                <div class="logo">LOG.GG</div>
            </a>

            <article class="view-container">
                <div class="post-header">
                    <%-- 🌟 우측 상단 수정/삭제 버튼 --%>
                    <sec:authorize access="isAuthenticated()">
                        <sec:authentication property="principal.userNo" var="loginUserNo"/>
                    </sec:authorize>
                    
                    <c:if test="${not empty loginUserNo and loginUserNo == board.userNo}">
                        <div class="post-util-btns">
                            <button type="button" onclick="location.href='<c:url value="/board/edit?boardNo=${board.boardNo}"/>'">수정</button>
                            <button type="button" class="delete" onclick="deleteBoard()">삭제</button>
                        </div>
                    </c:if>

                    <div class="post-category">${board.categoryName}</div>
                    <h1 class="post-title">${board.boardTitle}</h1>
                    <div class="post-info">
                        <span>글쓴이: <b>${board.userName}</b></span>
                        <span>날짜: <b><fmt:formatDate value="${board.postDate}" pattern="yyyy-MM-dd HH:mm"/></b></span>
                        <span>조회수: <b>${board.readCount}</b></span>
                    </div>
                </div>

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

                <div class="post-action">
                    <button type="button" class="btn-action like" id="btn-like" data-boardno="${board.boardNo}">
                        👍 공감 <b id="like-count">${board.likeCount}</b>
                    </button>
                    <button class="btn-action" onclick="location.href='<c:url value="/board/${boardTypePath}_${safeGameId}"/>'">목록으로</button>
                    <button class="btn-action report">🚨 신고</button>
                </div>

                <form id="deleteForm" action="<c:url value='/board/delete'/>" method="POST" style="display:none;">
                    <input type="hidden" name="boardNo" value="${board.boardNo}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                </form>

                <section class="comment-section">
                    <div class="comment-count" id="reply-count-display">댓글 0</div>
                    <div class="comment-form">
                        <textarea id="replyContent" placeholder="댓글을 남겨보세요."></textarea>
                        <button type="button" class="comment-submit" onclick="insertReply();">등록</button>
                    </div>
                    <div class="comment-list" id="reply-list-area"></div>
                </section>
            </article>
        </main>
        
        <aside class="side-right">
        </aside>
    </div>

    <footer>© 2026 LOG.GG 배틀그라운드 서비스. 모든 권리 보유.</footer>
</body>
</html>