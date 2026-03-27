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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/search/style.css">

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
                <a href="<c:url value ='/${gameId}/main'/>"><div class="logo">LOG.GG</div></a>

                <%-- 💖 검색창 영역: id="boardSearchInput" 유지 💖 --%>
                <div class="search-bar">
                    <input type="text" id="boardSearchInput" placeholder="${boardTitle} 내 글 검색"> 
                    <span style="cursor: pointer">🔍</span>
                </div>
            </div>

            <div class="board-header">
                <div class="board-title">${boardTitle}</div>
                <%-- 버튼 테두리 문제 해결을 위해 클래스 직접 부여 --%>
                <a href="<c:url value='${writeUrl}' />" class="btn-write">글쓰기</a>
            </div>

            <%-- 💖 기존의 예쁜 스타일이 적용된 하나뿐인 진짜 테이블! 💖 --%>
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
                <%-- 💖 tbody에 id 추가 💖 --%>
                <tbody id="boardTableBody">
                    <c:choose>
                        <c:when test="${empty boardList}">
                            <tr>
                                <td colspan="6" class="empty-msg">게시글이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="post" items="${boardList}">
                                <%-- 💖 검색 필터링을 조종하기 위한 class 추가 💖 --%>
                                <tr class="board-row-item">
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

    <%-- 💖 게시판 리스트 즉시 필터링 자바스크립트 💖 --%>
    <script>
        $(document).ready(function() {
            $("#boardSearchInput").on("keyup", function() {
                // 1. 검색창에 입력한 값을 소문자로 가져옵니다.
                let searchValue = $(this).val().toLowerCase();

                // 2. 테이블의 모든 행(tr)을 돌면서 검사합니다.
                $("#boardTableBody .board-row-item").filter(function() {
                    // 3. 제목(td.td-title)의 텍스트와 검색어를 비교해서
                    // 포함되어 있으면 보여주고, 없으면 숨깁니다(toggle).
                    let titleText = $(this).find(".td-title").text().toLowerCase();
                    $(this).toggle(titleText.indexOf(searchValue) > -1);
                });
            });
        });
    </script>
</body>
</html>