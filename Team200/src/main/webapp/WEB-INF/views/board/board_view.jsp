<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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
        <aside class="side-left">
            <div class="side-card">
                <h3>카테고리</h3>
                <div class="menu-item" onclick="location.href='gallery.html'">갤러리</div>
                
                <div class="menu-item-group">
                    <div class="menu-item">게시판</div>
                    <div class="sub-menu-container"> 
                        <div class="sub-item ${boardTypePath == 'free' ? 'active' : ''}" onclick="location.href='<c:url value="/board/free_${safeGameId}"/>'">자유게시판</div>
                        <div class="sub-item" ${boardTypePath == 'strategy' ? 'active' : ''}" onclick="location.href='<c:url value="/board/strategy_${safeGameId}"/>'">공략게시판</div>
                    </div>
                </div>
                
                <div class="menu-item" onclick="location.href='qna-list.html'">고객지원</div>
            </div>
        </aside>

        <main class="content-area">
            <div class="logo">LOG.GG</div>

            <article class="view-container">
                <div class="post-header">
                    <div class="post-category">${board.categoryName}</div>
                    <h1 class="post-title">${board.boardTitle}</h1>
                    <div class="post-info">
                        <span>글쓴이: <b>${board.userName}</b></span>
                        <span>날짜: <b><fmt:formatDate value="${board.postDate}" pattern="yyyy-MM-dd:HH:mm"/></b></span>
                        <span>조회수: <b>${board.readCount}</b></span>
                    </div>
                </div>

                <div class="post-body" style="white-space: pre-wrap; line-height: 1.6;">${board.boardContent}
                    <c:if test="${not empty board.fileList}">
				        <div class="post-images" style="margin-top: 20px; text-align: center;">
				            <c:forEach var="file" items="${board.fileList}">
				                <%-- 업로드된 경로에 맞춰 이미지 태그 생성 --%>
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
                    <button class="btn-action report">🚨 신고</button>
                </div>

                <section class="comment-section">
                    <div class="comment-count">댓글 2</div>
                    
                    <div class="comment-form">
                        <textarea placeholder="댓글을 남겨보세요."></textarea>
                        <button class="comment-submit">등록</button>
                    </div>

                    <div class="comment-list">
                        <div class="comment-item">
                            <div class="comment-author">배그초보</div>
                            <div class="comment-text">보통 수요일 오전 9시부터 오후 1시까지 하더라고요!</div>
                            <div class="comment-utils">
                                <span>답글</span> | <span>신고</span> | <span>공감</span>
                            </div>
                        </div>

                        <div class="comment-item reply">
                            <div class="comment-author">ㄴ 글쓴이</div>
                            <div class="comment-text">아하 그렇군요! 답변 감사합니다 :)</div>
                            <div class="comment-utils">
                                <span>신고</span> | <span>공감</span>
                            </div>
                        </div>
                    </div>
                </section>
            </article>
        </main>

        <aside class="side-right">
            <div class="side-card">
                <h3>${gameName} 소식</h3>
                <p>
                    최신 패치노트와 공략을 확인하고<br>
                    승률을 높여보세요!<br>
                    현재 시즌 28 진행 중입니다.
                </p>
                <button class="btn-more">자세히 보기</button>
            </div>
        </aside>
    </div>

    <footer>© 2026 LOG.GG 배틀그라운드 서비스. 모든 권리 보유.</footer>

</body>
</html>