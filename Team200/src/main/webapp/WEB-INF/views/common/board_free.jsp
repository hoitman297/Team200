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
    <script src="${pageContext.request.contextPath}/resources/board/board_main/script.js" defer></script>
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
			    <%-- ✨ [수정] 패치노트 혹은 공지사항(isNotice)일 때는 통합 메인으로! --%>
                <c:choose>
                    <c:when test="${not empty isPatchnote or not empty isNotice or gameName == '공지사항'}">
                        <a href="<c:url value='/'/>"><div class="logo">LOG.GG</div></a>
                    </c:when>
                    <c:otherwise>	
                        <a href="<c:url value='/${gameId}/main'/>"><div class="logo">LOG.GG</div></a>
                    </c:otherwise>
                </c:choose>
                <c:set var="searchType" value="board" />
                <%@ include file="../common/search_bar.jsp" %>
            </div>

            <div class="board-header">
			    <div class="board-title">${boardTitle}</div>
			    
			   <%-- ✨ [수정] 패치노트 혹은 공지사항일 때는 글쓰기 버튼 숨기기 --%>
                <c:if test="${empty isPatchnote and empty isNotice}">
                    <sec:authorize access="isAuthenticated()">
                        <a href="<c:url value='${writeUrl}' />" class="btn-write">글쓰기</a>
                    </sec:authorize>
                </c:if>
			</div>

            <table class="list-table">
                <thead>
                    <tr>
                        <th style="width: 60px;">번호</th>
                        <th>제목</th>
                        <th style="width: 100px;">글쓴이</th>
                        <th style="width: 100px;">날짜</th>
                        <th style="width: 80px;">조회수</th>
                        <c:if test="${empty isPatchnote and empty isNotice}">
                            <th style="width: 60px;">공감</th>
                        </c:if>
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
                            	
                            	<%-- ✨ [핵심 수정] 클릭 시 상세 페이지 경로 분기 처리 --%>
                                <c:choose>
									    <c:when test="${not empty isPatchnote}">
									        <c:set var="detailLink" value="/board/patchnoteView?boardNo=${post.boardNo}" />
									    </c:when>
									    
									    <%-- 2. 공지사항일 때 가는 길 (이걸 추가해야 합니다! ⭐️) --%>
									    <c:when test="${not empty isNotice or gameName == '공지사항'}">
									        <c:set var="detailLink" value="/board/noticeView?boardNo=${post.boardNo}" />
									    </c:when>
									    
									    <%-- 3. 일반 게시판일 때 가는 길 --%>
									    <c:otherwise>
									        <c:set var="detailLink" value="/board/view?boardNo=${post.boardNo}" />
									    </c:otherwise>
									</c:choose>
                            
                            
                                <tr class="board-row-item" data-href="${pageContext.request.contextPath}${detailLink}">
                                    <td>${post.boardNo}</td>
                                    <td class="td-title">
									    <%-- ✨ 전체 패치노트 화면일 때만 말머리(태그) 표시! --%>
									    <c:if test="${gameId == 'all' and gameName == '패치노트'}">
									        <c:choose>
									            <c:when test="${post.gameCode == 'LOL'}">
									                <span style="color: #00a8ff; font-weight: bold; margin-right: 5px; font-size: 13px;">[LOL]</span>
									            </c:when>
									            <c:when test="${post.gameCode == 'OW'}">
									                <span style="color: #ff9f43; font-weight: bold; margin-right: 5px; font-size: 13px;">[OW]</span>
									            </c:when>
									            <c:when test="${post.gameCode == 'BG'}">
									                <span style="color: #ffb142;   font-size: 13px; margin-right: 5px; font-size: 13px;">[배그]</span>
									            </c:when>
									        </c:choose>
									    </c:if>
                                        <a href="${pageContext.request.contextPath}${detailLink}">${post.boardTitle}</a>
                                        <c:if test="${loginUserNo == post.userNo}">
                                            <span class="my-post-tag" style="color: #3b82f6; font-size: 11px; font-weight: bold; margin-left: 5px;">[내 글]</span>
                                        </c:if> 
                                        <%-- ✨ [수정] 공지사항도 보통 댓글이 없으므로, 패치노트처럼 댓글 수도 숨기고 싶다면 체크! --%>
                                        <c:if test="${post.replyCount > 0 and empty isNotice}">
                                            <span style="color: var(--accent-blue); font-weight: bold; font-size: 13px; margin-left: 5px;">[${post.replyCount}]</span>
                                        </c:if>
                                    </td>
                                    <td>${post.userName}</td>
                                    <td><fmt:formatDate value="${post.postDate}" pattern="yyyy-MM-dd" /></td>
                                    <td>${post.readCount}</td>
                                    <%-- ✨ [수정] 공지사항도 공감 데이터 숨기기 --%>
                                    <c:if test="${empty isPatchnote and empty isNotice}">
                                        <td>${post.likeCount}</td>
                                    </c:if>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

			<div class="pagination">
				<%-- 이전 버튼 --%>
				<c:if test="${pi.currentPage > 1}">
					<a href="?cp=${pi.currentPage - 1}&keyword=${param.keyword}"
						class="page-link">&lt; 이전</a>
				</c:if>

				<%-- 페이지 번호 --%>
				<c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
					<c:choose>
						<c:when test="${p == pi.currentPage}">
							<span class="page-num active">${p}</span>
						</c:when>
						<c:otherwise>
							<a href="?cp=${p}&keyword=${param.keyword}" class="page-num">${p}</a>
						</c:otherwise>
					</c:choose>
				</c:forEach>

				<%-- 다음 버튼 --%>
				<c:if test="${pi.currentPage < pi.maxPage}">
					<a href="?cp=${pi.currentPage + 1}&keyword=${param.keyword}"
						class="page-link">다음 &gt;</a>
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