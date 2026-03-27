<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/free_main/style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
	<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
    <script src="${pageContext.request.contextPath}/resources/board/free_main/script.js"></script>
    
    <style>
        a, a:hover, a:visited, a:active {
            text-decoration: none !important;
            color: inherit !important;
        }
    </style>
    
    <title>LOG.GG - 게시판 검색</title>
</head>
<body>
    <c:set var="headerTitle" value="게시판" />
	<%@ include file="../common/header.jsp" %>

    <div class="main-layout">
        <aside class="side-left">
            <div class="side-card">
                <h3>카테고리</h3>
                <div class="menu-item">갤러리</div>
                
                <div class="menu-item-group">
                    <div class="menu-item">게시판</div>
                    <div class="sub-menu-container">
                        <a href="<c:url value = '/board/free' />"><div class="sub-item">자유게시판</div></a>
                        <a href="<c:url value = '/board/strategy' />"><div class="sub-item">공략게시판</div></a>
                    </div>
                </div>
                
                <div class="menu-item">고객지원</div>
            </div>
        </aside>

        <main class="content-area">
            <div class="board-top-row">
                <a href="<c:url value = '/' />"><div class="logo">LOG.GG</div></a>
                <div class="search-bar">
                    <input type="text" placeholder="게시판 내 글 검색">
                    <span style="cursor:pointer">🔍</span>
                </div>
            </div>

            <div class="board-header">
                <div class="board-title">자유 게시판</div>
                <sec:authorize access="hasAnyRole('ROLE_USER','ROLE_ADMIN')">
                <a href="<c:url value = '/board/free/write/${gameCode}'/>"><button class="btn-write">글쓰기</button></a>
                </sec:authorize>
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
                    <tr>
                        <td>${board.boardNo}</td>
                        <td class="td-title">${board.boardTitle}</td>
                        <td>${board.userNo}</td>
                        <td>${board.postDate}</td>
                        <td>${board.readCount}</td>
                        <td>${boardLikes}</td>
                    </tr>   
                    <tr>
                        <td>001</td>
                        <td class="td-title">안녕하세요! 신규 유저 인사드립니다.</td>
                        <td>user01</td>
                        <td>25-01-24</td>
                        <td>12</td>
                        <td>2</td>
                    </tr>
                </tbody>
            </table>

            <div class="pagination">
                <span>&lt; 이전</span>
                <span class="page-num active">1</span>
                <span class="page-num">2</span>
                <span class="page-num">3</span>
                <span class="page-num">4</span>
                <span class="page-num">5</span>
                <span>다음 &gt;</span>
            </div>
        </main>

        <aside class="sidebar-right" style="background: #cbd5e1; border-radius: 20px; padding: 25px; height: fit-content;">
            <h3 style="font-size: 16px; margin: 0 0 20px 0; font-weight: 800;">알림</h3>
            <div style="font-size: 14px; color: #475569; line-height: 1.8;">
                검색 기능을 통해 이전에 올라온 꿀팁들을 쉽게 찾아보실 수 있습니다.
            </div>
        </aside>
    </div>

    <footer>© 2026 LOG.GG 배틀그라운드 서비스. 모든 권리 보유.</footer>

</body>
</html>