<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/member/user_activity/style.css">
	<script src="${pageContext.request.contextPath}/resources/member/user_activity/script.js"></script>
	
    <title>LOG.GG - 나의 활동 내역</title>
</head>
<body>

    <div class="activity-container">
        <div class="header">
            <h1>📝 나의 활동 내역</h1>
            <div class="stats">작성한 게시글 총 <b>${totalBoardCount}</b>개 | 댓글 <b>${totalReplyCount}</b>개</div>
        </div>

        <div class="tab-menu">
            <div class="tab-item ${currentType == 'board' ? 'active' : ''}" onclick="location.href='?type=board&game=${currentGame}'" style="cursor: pointer;">작성한 게시글</div>
            <div class="tab-item ${currentType == 'reply' ? 'active' : ''}" onclick="location.href='?type=reply&game=${currentGame}'" style="cursor: pointer;">작성한 댓글</div>
        </div>

        <div class="game-filter">
            <button class="filter-btn ${currentGame == 'all' ? 'active' : ''}" onclick="location.href='?type=${currentType}&game=all'">전체</button>
            <button class="filter-btn ${currentGame == 'lol' ? 'active' : ''}" onclick="location.href='?type=${currentType}&game=lol'">리그 오브 레전드</button>
            <button class="filter-btn ${currentGame == 'battleground' ? 'active' : ''}" onclick="location.href='?type=${currentType}&game=battleground'">배틀그라운드</button>
            <button class="filter-btn ${currentGame == 'overwatch' ? 'active' : ''}" onclick="location.href='?type=${currentType}&game=overwatch'">오버워치</button>
        </div>

        <table class="activity-table">
            <thead>
                <tr>
                    <%-- ✨ 4. 게시글/댓글 탭에 따라 테이블 헤더가 다르게 출력됩니다. --%>
                    <c:choose>
                        <c:when test="${currentType == 'board'}">
                            <th style="width: 60%;">제목</th>
                            <th style="width: 20%;">날짜</th>
                            <th style="width: 10%;">조회</th>
                            <th style="width: 10%;">공감</th>
                        </c:when>
                        <c:otherwise>
                            <th style="width: 60%;">댓글 내용</th>
                            <th style="width: 20%;">작성일</th>
                            <th style="width: 20%;">게시판</th>
                        </c:otherwise>
                    </c:choose>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <%-- 데이터가 없을 때 --%>
                    <c:when test="${empty list}">
                        <tr>
                            <td colspan="${currentType == 'board' ? 4 : 3}" style="text-align:center; padding: 50px 0; color: #94a3b8;">
                                ${currentType == 'board' ? '작성한 게시글이 없습니다.' : '작성한 댓글이 없습니다.'}
                            </td>
                        </tr>
                    </c:when>
                    
                    <%-- 데이터가 있을 때 --%>
                    <c:otherwise>
                        <c:forEach var="item" items="${list}">
                            <%-- BoardExt(게시글)와 Map(댓글)의 변수명(대소문자)이 다르므로 분기 처리해서 담아줍니다 --%>
                            <c:set var="gameCode" value="${currentType == 'board' ? item.gameCode : item.GAME_CODE}" />
                            <c:set var="upCode" value="${fn:toUpperCase(gameCode)}" />
                            
                            <tr>
                                <td>
                                    <%-- 게임 태그 뱃지 색상 동적 변경 --%>
                                    <c:choose>
                                        <c:when test="${upCode == 'BG' or upCode == 'BATTLEGROUND'}"><span class="game-tag tag-pubg">PUBG</span></c:when>
                                        <c:when test="${upCode == 'LOL'}"><span class="game-tag tag-lol">LoL</span></c:when>
                                        <c:when test="${upCode == 'OW' or upCode == 'OVERWATCH'}"><span class="game-tag tag-ow">OW2</span></c:when>
                                        <c:otherwise><span class="game-tag" style="background:#cbd5e1; color:#fff;">기타</span></c:otherwise>
                                    </c:choose>

                                    <%-- 제목 및 내용 출력 영역 --%>
                                    <c:choose>
                                        <c:when test="${currentType == 'board'}">
                                            <a href="<c:url value='/board/view?boardNo=${item.boardNo}' />" class="post-title"><c:out value="${item.boardTitle}"/></a>
                                            <c:if test="${item.replyCount > 0}">
                                                <span class="comment-count">[${item.replyCount}]</span>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="<c:url value='/board/view?boardNo=${item.BOARD_NO}' />" class="post-title" style="display:inline-block; max-width:80%; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; vertical-align:middle;">
                                                <c:out value="${item.REPLY_CONTENT}"/>
                                            </a>
                                            <div style="font-size: 13px; color: #94a3b8; margin-top: 5px; margin-left: 55px;">
                                                원문: <c:out value="${item.BOARD_TITLE}"/>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <%-- 나머지 메타 정보 영역 --%>
                                <c:choose>
                                    <c:when test="${currentType == 'board'}">
                                        <td class="meta-info"><fmt:formatDate value="${item.postDate}" pattern="yyyy.MM.dd"/></td>
                                        <td class="meta-info"><fmt:formatNumber value="${item.readCount}" pattern="#,###"/></td>
                                        <td class="meta-info" style="color: #475569;">+${item.likeCount}</td>
                                    </c:when>
                                    <c:otherwise>
                                        <td class="meta-info"><fmt:formatDate value="${item.REPLY_DATE}" pattern="yyyy.MM.dd HH:mm"/></td>
                                        <td class="meta-info"><c:out value="${item.CATEGORY_NAME}"/></td>
                                    </c:otherwise>
                                </c:choose>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <%-- ✨ 5. 페이징 영역 (1:1 문의 스타일 그대로 적용) --%>
        <c:if test="${not empty list}">
            <div class="pagination" style="text-align: center; margin-top: 30px;">
                <c:if test="${pi.currentPage > 1}">
                    <a href="?type=${currentType}&game=${currentGame}&cp=${pi.currentPage - 1}" class="page-link" style="padding: 5px 10px; border: 1px solid #e2e8f0; border-radius: 4px; text-decoration: none; color: #475569;">&lt;</a>
                </c:if>
                
                <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
                    <a href="?type=${currentType}&game=${currentGame}&cp=${p}" class="page-num ${p == pi.currentPage ? 'active' : ''}" style="padding: 5px 10px; border: 1px solid #e2e8f0; border-radius: 4px; text-decoration: none; ${p == pi.currentPage ? 'background: #3b82f6; color: white; border-color: #3b82f6;' : 'color: #475569;'}">${p}</a>
                </c:forEach>
                
                <c:if test="${pi.currentPage < pi.maxPage}">
                    <a href="?type=${currentType}&game=${currentGame}&cp=${pi.currentPage + 1}" class="page-link" style="padding: 5px 10px; border: 1px solid #e2e8f0; border-radius: 4px; text-decoration: none; color: #475569;">&gt;</a>
                </c:if>
            </div>
        </c:if>

        <a href="${pageContext.request.contextPath}/member/mypage" class="btn-back" style="display: inline-block; margin-top: 20px;">이전 페이지</a>
    </div>

</body>
</html>