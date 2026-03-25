<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <%-- CSS 경로 확인 필수! --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/board_main/style.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
    
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
                <a href="<c:url value='/' />" class="logo-link"><div class="logo">LOG.GG</div></a>
                <div class="search-bar">
                    <input type="text" placeholder="${boardTitle} 내 글 검색">
                    <span style="cursor:pointer">🔍</span>
                </div>
            </div>

            <div class="board-header">
                <div class="board-title">${boardTitle}</div>
                <%-- 버튼 테두리 문제 해결을 위해 클래스 직접 부여 --%>
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
                <tbody>
                    <c:choose>
                        <c:when test="${empty boardList}">
                            <tr>
                                <td colspan="6" class="empty-msg">게시글이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="post" items="${boardList}">
                                <tr>
                                    <td>${post.id}</td>
                                    <td class="td-title">${post.title}</td>
                                    <td>${post.writer}</td>
                                    <td>${post.date}</td>
                                    <td>${post.views}</td>
                                    <td>${post.likes}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
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