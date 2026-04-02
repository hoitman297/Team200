<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<%-- 1. 게임 이름 및 경로 설정 --%>
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

<%-- 2. 게시판 타입 판별 (갤러리 여부 체크 추가) --%>
<c:choose>
    <c:when test="${fn:contains(board.categoryName, '갤러리')}">
        <c:set var="boardTypePath" value="gallery" />
    </c:when>
    <c:when test="${fn:contains(board.categoryName, '공략')}">
        <c:set var="boardTypePath" value="strategy" />
    </c:when>
    <c:otherwise>
        <c:set var="boardTypePath" value="free" />
    </c:otherwise>
</c:choose>

<%-- 로그인한 유저 번호 추출 --%>
<c:set var="secUserNo" value="0" />
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal.userNo" var="secUserNo" />
</sec:authorize>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <sec:csrfMetaTags />
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    
    <title>LOG.GG - ${board.boardTitle}</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/board_view/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

    <script>
        const contextPath = "${pageContext.request.contextPath}";
        const currentBoardNo = ${board.boardNo};
    </script>
    
    <script src="${pageContext.request.contextPath}/resources/board/board_view/script.js" defer></script>
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
</head>
<body>  
    <c:set var="headerTitle" value="${gameName}" />
    <%@ include file="../common/header.jsp" %>

    <div class="main-layout">
        <aside class="side-left">
            <div class="side-card">
                <h3>카테고리</h3>

                <a href="${pageContext.request.contextPath}/gallery/list" class="menu-link" style="text-decoration: none; color: inherit;">
                    <div class="menu-item ${boardTypePath == 'gallery' ? 'active' : ''}">갤러리</div>
                </a>

                <div class="menu-item-group">
                    <div class="menu-item">게시판</div>
                    <div class="sub-menu-container"> 
                        <div class="sub-item ${boardTypePath == 'free' ? 'active' : ''}" onclick="location.href='<c:url value="/board/free_${safeGameId}"/>'">자유게시판</div>
                        <div class="sub-item ${boardTypePath == 'strategy' ? 'active' : ''}" onclick="location.href='<c:url value="/board/strategy_${safeGameId}"/>'">공략게시판</div>
                    </div>
                </div>
                
                <a href="${pageContext.request.contextPath}/board/inquiry" class="menu-link" style="text-decoration: none; color: inherit;">
                    <div class="menu-item">고객지원</div>
                </a>
            </div>
        </aside>

        <main class="content-area">
            <a href="<c:url value='/' />" style="text-decoration: none; color: inherit;">
                <div class="logo">LOG.GG</div>
            </a>

            <article class="view-container">
                <div class="post-header">
                    <div class="post-category">${board.categoryName}</div>
                    <h1 class="post-title">${board.boardTitle}</h1>
                    <div class="post-info">
                        <span>글쓴이: <b>${board.userName}</b></span>
                        <span>날짜: <b><fmt:formatDate value="${board.postDate}" pattern="yyyy-MM-dd HH:mm"/></b></span>
                        <span>조회수: <b>${board.readCount}</b></span>
                    </div>

                    <div class="post-util-btns">
                        <c:if test="${secUserNo != 0 and secUserNo == board.userNo}">
                            <button type="button" onclick="location.href='<c:url value="/board/edit?boardNo=${board.boardNo}"/>'">수정</button>
                            <button type="button" class="delete" onclick="if(confirm('정말 삭제하시겠습니까?')) { location.href='<c:url value="/board/delete?boardNo=${board.boardNo}"/>'; }">삭제</button>
                        </c:if>
                        <c:if test="${secUserNo != board.userNo}">
                            <sec:authorize access="hasRole('ADMIN')">
                                <button type="button" class="delete" onclick="if(confirm('관리자 권한으로 강제 삭제하시겠습니까?')) { location.href='<c:url value="/board/delete?boardNo=${board.boardNo}"/>'; }">삭제(관리자)</button>
                            </sec:authorize>
                        </c:if>
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
                    
                    <%-- 3. 목록으로 버튼 경로 수정: 갤러리일 때와 아닐 때를 구분 --%>
                    <c:choose>
                        <c:when test="${boardTypePath == 'gallery'}">
                            <button class="btn-action" onclick="location.href='<c:url value="/gallery/list?gameCode=${board.gameCode}"/>'">목록으로</button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn-action" onclick="location.href='<c:url value="/board/${boardTypePath}_${safeGameId}"/>'">목록으로</button>
                        </c:otherwise>
                    </c:choose>
                    
                    <button class="btn-action report" onclick="openReportModal('board', ${board.boardNo})">🚨 신고</button>
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
        
        <aside class="side-right"></aside>
    </div>
    
    <footer>© 2026 LOG.GG ${gameName} 서비스. 모든 권리 보유.</footer>

    <%-- 신고 모달 및 스크립트 생략 (기존과 동일) --%>
    <div id="reportModal" class="modal-overlay" style="display: none;">
        </div>

    <script>
        // ...기존 AJAX 및 스크립트 코드...
        const loginUserNo = "${secUserNo}";
        let isAdmin = false;
        <sec:authorize access="hasRole('ADMIN')">isAdmin = true;</sec:authorize>
        
        $(document).ready(function() {
            selectReplyList();
            // ... 좋아요 및 댓글 AJAX 로직들 ...
        });
        
        // (기존 스크립트 내용 유지)
    </script>
</body>
</html>