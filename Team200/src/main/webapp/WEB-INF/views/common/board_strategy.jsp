<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/board_main/style.css">
    <%-- 💖 공통 검색창 CSS로 경로 수정 💖 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/search/style.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
    <%-- 💖 공통 검색창 JS 추가 💖 --%>
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
                
                <%-- 💖 마법의 주문! 공통 검색창을 게시판 모드(board)로 불러옵니다 💖 --%>
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

                    <%-- 🚨 깐깐한 c:choose 블록 (공백 완전 제거) 🚨 --%>
                    <c:choose><c:when test="${empty boardList}">
                        <tr>
                            <td colspan="6" class="empty-msg">게시글이 없습니다.</td>
                        </tr>
                    </c:when><c:otherwise>
                        <c:forEach var="post" items="${boardList}">
                            <tr class="board-row-item">
                                <td>${post.id}</td>
                                <td class="td-title">
                                    ${post.title}
                                    <%-- 💖 내가 쓴 글이면 제목 옆에 '[내 글]' 표시 추가 💖 --%>
                                    <c:if test="${not empty sessionScope.loginUser and sessionScope.loginUser.userNo == post.userNo}">
                                        <span class="my-post-tag" style="color: #3b82f6; font-size: 11px; font-weight: bold; margin-left: 5px;">[내 글]</span>
                                    </c:if>
                                </td>
                                <td>${post.writer}</td>
                                <td>${post.date}</td>
                                <td>${post.views}</td>
                                <td>${post.likes}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise></c:choose>
                </tbody>
            </table>

            <div class="pagination">
                <span class="page-link">&lt; 이전</span>
                <span class="page-num active">1</span>
                <span class="page-num">2</span>
                <span class="page-num">3</span>
                <span class="page-link">다음 &gt;</span>
            </div>
        </main>

        <aside class="sidebar-right">
            <div class="notice-card">
                <h3>공지사항</h3>
                <div class="notice-content">
                    ${boardNotice}
                </div>
            </div>
        </aside>
    </div>

    <footer>© 2026 LOG.GG ${gameName} 서비스. 모든 권리 보유.</footer>

</body>
</html>