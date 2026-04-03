<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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

<c:set var="upperCode" value="${fn:toUpperCase(inq.gameCode)}" />
<c:set var="tagGameName">
    <c:choose>
        <c:when test="${upperCode == 'BG' or upperCode == 'BATTLEGROUND'}">배그</c:when>
        <c:when test="${upperCode == 'LOL'}">롤</c:when>
        <c:when test="${upperCode == 'OW' or upperCode == 'OVERWATCH'}">옵치</c:when>
        <c:otherwise>기타</c:otherwise>
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
                            <%-- 상태에 따른 뱃지 출력 --%>
                            <c:choose>
                                <c:when test="${inq.answerStatus == 'W'}">
                                    <span class="status-badge waiting">답변대기</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge completed" style="background-color: #10b981; color: white;">답변완료</span>
                                </c:otherwise>
                            </c:choose>
                            
                            <%-- 게임 태그 및 제목 --%>
                            <h3>
                                <span style="color: var(--accent-blue); margin-right: 8px;">[${tagGameName}]</span> 
                                <c:out value="${inq.boardTitle}" />
                            </h3>
                        </div>
                        <div class="view-meta">
                            <span class="meta-item">작성자: <strong>${inq.userName}</strong></span>
                            <span class="meta-item divider">|</span>
                            <span class="meta-item">작성일: <fmt:formatDate value="${inq.postDate}" pattern="yyyy-MM-dd HH:mm" /></span>
                        </div>
                    </div>

                    <%-- ✨ white-space: pre-wrap을 줘서 줄바꿈이 그대로 유지되게 합니다 --%>
                    <div class="view-content" style="white-space: pre-wrap; line-height: 1.6;"><c:out value="${inq.boardContent}" /></div>
                </div>

                <%-- ✨ 관리자 답변 (답변 완료(C) 상태이고 답변 내용이 있을 때만 노출) --%>
                <c:if test="${inq.answerStatus == 'C' and not empty inq.answer}">
                    <div class="answer-container">
                        <div class="answer-header">
                            <div class="admin-profile">
                                <div class="admin-icon">GM</div>
                                <strong>LOG.GG 고객지원팀</strong>
                            </div>
                        </div>
                        <div class="answer-content" style="white-space: pre-wrap; line-height: 1.6;">
                            <c:out value="${inq.answer}" />
                        </div>
                    </div>
                </c:if>

                <div class="view-footer">
                    <div class="footer-left">
                        <%-- 목록으로 돌아갈 때 현재 게임 탭 유지 --%>
                        <button type="button" class="btn-list" onclick="location.href='<c:url value='/board/inquiry?game=${currentGame}' />'">목록으로</button>
                    </div>
                    <div class="footer-right">
                        <%-- 본인 작성글일 경우에만 수정/삭제 노출 --%>
                        <c:if test="${inq.answerStatus == 'W'}">
<%--                             <button type="button" class="btn-edit" onclick="location.href='<c:url value='/board/inquiryEdit?boardNo=${inq.boardNo}' />'">수정</button> --%>
                            <button type="button" class="btn-delete" onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='<c:url value='/board/inquiryDelete?boardNo=${inq.boardNo}' />'">삭제</button>
                        </c:if>
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