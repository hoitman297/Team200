<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <%-- CSS 경로 확인 필수! --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/board_main/style.css">
    <%-- 💖 우리가 만든 공통 검색창 CSS 추가 💖 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/search/style.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
    <%-- 💖 우리가 만든 공통 검색창 JS 추가 💖 --%>
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
                                    <td class="td-title">
									    <a href="<c:url value='/board/view?boardNo=${post.boardNo}' />" style="text-decoration: none; color: inherit;">
									        ${post.boardTitle}
									        
									        <%-- ✨ 댓글이 1개 이상일 때만 제목 옆에 파란색으로 개수 표시! ✨ --%>
									        <c:if test="${post.replyCount > 0}">
									            <span style="color: var(--accent-blue); font-weight: bold; font-size: 13px; margin-left: 5px;">
									                [${post.replyCount}]
									            </span>
									        </c:if>
									    </a>
									</td>
                                    <td>${post.userName}</td>
                                    <td><fmt:formatDate value="${post.postDate}" pattern="yyyy-MM-dd"/></td>
                                    <td>${post.readCount}</td>
                                    <td>${post.likeCount}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
		
            <div class="pagination">
			    <%-- 이전 페이지 --%>
			    <c:if test="${pi.currentPage > 1}">
			        <a href="?cp=${pi.currentPage - 1}" class="page-link">&lt; 이전</a>
			    </c:if>
			
			    <%-- 페이지 번호 반복문 --%>
			    <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
			        <c:choose>
			            <c:when test="${p == pi.currentPage}">
			                <span class="page-num active">${p}</span> <%-- 현재 페이지 --%>
			            </c:when>
			            <c:otherwise>
			                <a href="?cp=${p}" class="page-num">${p}</a>
			            </c:otherwise>
			        </c:choose>
			    </c:forEach>
			
			    <%-- 다음 페이지 --%>
			    <c:if test="${pi.currentPage < pi.maxPage}">
			        <a href="?cp=${pi.currentPage + 1}" class="page-link">다음 &gt;</a>
			    </c:if>
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