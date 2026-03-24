<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/board_main/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    <c:if test="${not empty gameThemeCss}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/${gameThemeCss}">
    </c:if>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
    
    <style>
        a, a:hover, a:visited, a:active {
            text-decoration: none !important;
            color: inherit !important;
        }
    </style>
    
    <title>LOG.GG - ${boardTitle}</title>
</head>
<body>
    <c:set var="headerTitle" value="${gameName}" />
    <%@ include file="../common/header.jsp" %>

    <div class="main-layout">
        <aside class="side-left">
            <div class="side-card">
                <h3>카테고리</h3>
                <a href="<c:url value='/gallery/list' />"><div class="menu-item">갤러리</div></a>
                
                <div class="menu-item-group">
                    <div class="menu-item">게시판</div>
                    <div class="sub-menu-container">
                        <a href="<c:url value='/board/free_main_${gameId}' />"><div class="sub-item">자유게시판</div></a>
                        <a href="<c:url value='/board/strategy' />"><div class="sub-item">공략게시판</div></a>
                    </div>
                </div>
                
                <a href="<c:url value='/board/inquiry' />"><div class="menu-item">고객지원</div></a>
            </div>
        </aside>

        <main class="content-area">
            <div class="board-top-row">
                <a href="<c:url value='/' />"><div class="logo">LOG.GG</div></a>
                <div class="search-bar">
                    <input type="text" placeholder="${boardTitle} 내 글 검색">
                    <span style="cursor:pointer">🔍</span>
                </div>
            </div>

            <div class="board-header">
                <div class="board-title">${boardTitle}</div>
               <a href="<c:url value = '/board/free_write_${gameId}' />"><button class="btn-write">글쓰기</button></a>
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
                                <td colspan="6" style="padding: 50px; color: #94a3b8;">게시글이 없습니다.</td>
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
                <span>&lt; 이전</span>
                <span class="page-num active">1</span>
                <span class="page-num">2</span>
                <span class="page-num">3</span>
                <span>다음 &gt;</span>
            </div>
        </main>

        <aside class="sidebar-right" style="background: #cbd5e1; border-radius: 20px; padding: 25px; height: fit-content;">
            <h3 style="font-size: 16px; margin: 0 0 20px 0; font-weight: 800;">공지사항</h3>
            <div style="font-size: 14px; color: #475569; line-height: 1.8;">
                ${boardNotice}
            </div>
        </aside>
    </div>

    <footer>© 2026 LOG.GG ${gameName} 서비스. 모든 권리 보유.</footer>
</body>
</html>