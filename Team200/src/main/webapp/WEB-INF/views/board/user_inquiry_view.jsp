<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 목록으로 돌아갈 때 원래 있던 탭을 유지하기 위해 game 값을 받습니다! --%>
<c:set var="currentGame" value="${empty param.game ? 'all' : param.game}" />

<c:set var="displayGameName">
    <c:choose>
        <c:when test="${currentGame == 'battleground'}">배틀그라운드</c:when>
        <c:when test="${currentGame == 'lol'}">리그 오브 레전드</c:when>
        <c:when test="${currentGame == 'overwatch'}">오버워치</c:when>
        <c:otherwise>전체</c:otherwise>
    </c:choose>
</c:set>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/user_inquiry_view/style.css">
    <script src="${pageContext.request.contextPath}/resources/board/user_inquiry_view/script.js" defer></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    
    <title>LOG.GG - 문의 상세보기</title>
</head>
<body>
    <c:set var="headerTitle" value="${displayGameName} 고객지원" />
    <%@ include file="../common/header.jsp" %>

    <div class="main-layout">
        <aside class="side-left">
            <%@ include file="../common/sidebar.jsp" %>
        </aside>

        <main class="content-area">
            <a href="<c:url value ='/'/>"><div class="logo">LOG.GG</div></a>
            
            <div class="content-card">
                <div class="board-header">
                    <h2 class="board-title">문의 확인</h2>
                </div>

                <div class="view-container">
                    <div class="view-header">
                        <div class="view-title">
                            <span class="status-badge waiting">답변대기</span>
                            <h3><span style="color: var(--accent-blue); margin-right: 8px;">[계정/로그인 문의]</span> 로그인 오류가 계속 발생합니다.</h3>
                        </div>
                        <div class="view-meta">
                            <span class="meta-item">작성자: <strong>USER01</strong></span>
                            <span class="meta-item divider">|</span>
                            <span class="meta-item">작성일: 2026-03-09 14:30</span>
                        </div>
                    </div>

                    <div class="view-content">
                        로그인을 하려고 하는데 비밀번호가 맞음에도 불구하고 계속 오류 메시지가 뜹니다.<br>
                        캐시 삭제도 해봤는데 안 되네요. 빠른 확인 부탁드립니다!<br><br>
                        (오류 스크린샷 링크: https://imgur.com/example)
                    </div>
                </div>

                <div class="answer-container">
                    <div class="answer-header">
                        <div class="admin-profile">
                            <div class="admin-icon">GM</div>
                            <strong>LOG.GG 고객지원팀</strong>
                        </div>
                        <span class="answer-date">2026-03-09 15:10</span>
                    </div>
                    <div class="answer-content">
                        안녕하세요, USER01님.<br>
                        LOG.GG 고객지원팀입니다.<br><br>
                        현재 특정 브라우저 환경에서 로그인 세션이 충돌하는 현상이 확인되어 담당 부서에서 수정 중에 있습니다.<br>
                        크롬(Chrome) 시크릿 모드나 다른 브라우저(Edge 등)를 이용해 임시로 접속해 주시길 권장해 드립니다.<br>
                        이용에 불편을 드려 대단히 죄송합니다.<br><br>
                        감사합니다.
                    </div>
                </div>

                <div class="view-footer">
                    <div class="footer-left">
                        <%-- 목록으로 돌아갈 때 현재 게임 탭 유지 --%>
                        <button type="button" class="btn-list" onclick="location.href='<c:url value='/board/inquiry?game=${currentGame}' />'">목록으로</button>
                    </div>
                    <div class="footer-right">
                        <%-- 본인 작성글일 경우에만 수정/삭제 노출 --%>
                        <button type="button" class="btn-edit" onclick="location.href='#'">수정</button>
                        <button type="button" class="btn-delete" onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='#'">삭제</button>
                    </div>
                </div>

            </div>
        </main>

        <aside class="side-right">
            <div class="side-card" style="background: #cbd5e1; min-height: 200px;">
                <h3>상담 시간</h3>
                <p style="font-size: 14px; color: #475569; line-height: 1.7; font-weight: 500;">
                    • 평일: 09:00 ~ 18:00<br>
                    • 점심: 12:00 ~ 13:00<br>
                    • 주말/공휴일 휴무<br><br>
                    추가적인 문의사항은 새 문의글을 작성해 주세요.
                </p>
            </div>
        </aside>
    </div>

    <footer>© 2026 LOG.GG ${displayGameName} 서비스. 모든 권리 보유.</footer>
</body>
</html>