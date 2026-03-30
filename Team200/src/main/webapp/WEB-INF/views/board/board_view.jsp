<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%-- 1. 스프링 시큐리티 태그 라이브러리 추가 --%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- 게임 이름 및 경로 설정을 위한 로직 --%>
<c:set var="safeGameId" value="${fn:toLowerCase(board.gameCode)}" />
<c:choose>
    <c:when test="${board.gameCode == 'BG'}"><c:set var="gameName" value="배틀그라운드"/></c:when>
    <c:when test="${board.gameCode == 'OW'}"><c:set var="gameName" value="오버워치"/></c:when>
    <c:otherwise><c:set var="gameName" value="리그 오브 레전드"/></c:otherwise>
</c:choose>
<c:set var="boardTypePath" value="${fn:contains(board.categoryName, '공략') ? 'strategy' : 'free'}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <%-- 2. AJAX 요청을 위한 CSRF 메타 태그 추가 (댓글 작성 시 필요) --%>
    <sec:csrfMetaTags />
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/board_view/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/board/board_view/script.js"></script>
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
    
    <title>LOG.GG - ${board.boardTitle}</title>
</head>
<body>  
    <c:set var="headerTitle" value="게시판" />
    <%@ include file="../common/header.jsp" %>

    <div class="main-layout">
        <%-- (중략: 사이드바 내용 동일) --%>
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
            <div class="logo">LOG.GG</div>

            <article class="view-container">
                <%-- (중략: 게시글 본문 내용 동일) --%>
                <div class="post-header">
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
                    <button class="btn-action like">👍 공감 <b>${board.likeCount}</b></button>
                    <button class="btn-action" onclick="location.href='<c:url value="/board/${boardTypePath}_${safeGameId}"/>'">목록으로</button>
                    
                    <c:if test="${not empty sessionScope.loginUser and sessionScope.loginUser.userNo == board.userNo}">
                        <button class="btn-action" onclick="location.href='<c:url value="/board/edit?boardNo=${board.boardNo}"/>'">수정</button>
                        <button class="btn-action" style="color: #ef4444;" onclick="if(confirm('정말 삭제하시겠습니까?')) { location.href='<c:url value="/board/delete?boardNo=${board.boardNo}"/>'; }">삭제</button>
                    </c:if>
                    
                    <button class="btn-action report">🚨 신고</button>
                </div>

                <%-- 댓글 섹션 --%>
                <section class="comment-section">
                    <div class="comment-count">댓글 2</div>
                    
                    <div class="comment-form">
                        <textarea id="commentContent" placeholder="댓글을 남겨보세요."></textarea>
                        <%-- 3. 버튼 클릭 시 호출되는 AJAX 등에 대비해 CSRF 토큰을 사용할 준비가 됨 --%>
                        <button class="comment-submit">등록</button>
                    </div>

                    <div class="comment-list">
                        <%-- 댓글 리스트 생략 --%>
                    </div>
                </section>
            </article>
        </main>
        <%-- (이하 생략) --%>
    </div>
</body>
</html>