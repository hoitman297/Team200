<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal.userNo" var="loginUserNo" />
</sec:authorize>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/board_main/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/search/style.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
    <script src="${pageContext.request.contextPath}/resources/search/script.js" defer></script>
    
    <title>LOG.GG - ${boardTitle}</title>
</head>
<body>
    <c:set var="headerTitle" value="${gameName}" />
    <%@ include file="../common/header.jsp" %>

    <div class="main-layout">
        <aside class="side-left">
            <%@ include file="../common/sidebar.jsp" %>
        </aside>

        <main class="content-area">
            <div class="board-top-row">
                <a href="<c:url value ='/${gameId}/main'/>"><div class="logo">LOG.GG</div></a>
                <c:set var="searchType" value="board" />
                <%@ include file="../common/search_bar.jsp" %>
            </div>

            <div class="board-header">
                <div class="board-title">${boardTitle}</div>
                <a href="<c:url value='${writeUrl}' />" class="btn-write">글쓰기</a>
            </div>

            <table class="list-table">
                <thead>
                    <tr>
                        <th style="width: 60px;">번호</th>
                        <th>제목</th>
                        <th style="width: 100px;">글쓴이</th>
                        <th style="width: 100px;">날짜</th>
                        <th style="width: 80px;">조회수</th>
                        <th style="width: 60px;">공감</th>
                    </tr>
                </thead>
                <tbody id="boardTableBody">
                    <c:choose>
                        <c:when test="${empty boardList}">
                            <tr>
                                <td colspan="6" class="empty-msg">게시글이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="post" items="${boardList}">
                                <tr class="board-row-item" data-href="${pageContext.request.contextPath}/board/view?boardNo=${post.boardNo}">
                                    <td>${post.id}</td>
                                    <td class="td-title">
                                        <a href="${pageContext.request.contextPath}/board/view?boardNo=${post.boardNo}">${post.boardTitle}</a>
                                        <c:if test="${loginUserNo == post.userNo}">
                                            <span class="my-post-tag" style="color: #3b82f6; font-size: 11px; font-weight: bold; margin-left: 5px;">[내 글]</span>
                                        </c:if> 
                                        <c:if test="${post.replyCount > 0}">
                                            <span style="color: var(--accent-blue); font-weight: bold; font-size: 13px; margin-left: 5px;">
                                                [${post.replyCount}]
                                            </span>
                                        </c:if>
                                    </td>
                                    <td>${post.userName}</td>
                                    <td><fmt:formatDate value="${post.postDate}" pattern="yyyy-MM-dd" /></td>
                                    <td>${post.readCount}</td>
                                    <td>${post.likeCount}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <div class="pagination">
                <c:if test="${pi.currentPage > 1}">
                    <a href="?cp=${pi.currentPage - 1}" class="page-link">&lt; 이전</a>
                </c:if>
                <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
                    <c:choose>
                        <c:when test="${p == pi.currentPage}">
                            <span class="page-num active">${p}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="?cp=${p}" class="page-num">${p}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <c:if test="${pi.currentPage < pi.maxPage}">
                    <a href="?cp=${pi.currentPage + 1}" class="page-link">다음 &gt;</a>
                </c:if>
            </div>
        </main>

        <aside class="sidebar-right">
            <div class="notice-card">
                <h3>공지사항</h3>
                <div class="notice-content">${boardNotice}</div>
            </div>
        </aside>
    </div>
    <footer>© 2026 LOG.GG ${gameName} 서비스. 모든 권리 보유.</footer>
</body>
</html>