<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%-- 1. 변수 설정: 주소창의 game 값을 읽어옴 (기본값 all) --%>
<c:set var="currentGame" value="${empty param.game ? 'all' : param.game}" />

<%-- 2. 헤더/푸터용 게임 이름 매칭 --%>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/user_inquiry/style.css">
    <script src="${pageContext.request.contextPath}/resources/board/user_inquiry/script.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
    
    <title>LOG.GG - 고객지원 </title>
</head>
<body>
    <c:set var="headerTitle" value="${displayGameName}" />
    <%@ include file="../common/header.jsp" %>

    <div class="main-layout">
        <aside class="side-left">
            <%-- 사이드바에서 현재 페이지가 고객지원임을 표시 --%>
            <%@ include file="../common/sidebar.jsp" %>
        </aside>

        <main class="content-area">
            <a href="<c:url value ='/'/>"><div class="logo">LOG.GG</div></a>
            
            <div class="content-card">
                <div class="board-header">
                    <h2 class="board-title">고객지원 (${displayGameName})</h2>
                    <%-- 문의하기 클릭 시 현재 게임 정보를 들고 가도록 설정 가능 --%>
                    <button class="btn-write" onclick="location.href='<c:url value='/board/inquiryWrite?game=${currentGame}' />'">문의하기</button>
                </div>

                <%-- ✨ 추가: 게임 분류 필터 탭 (갤러리와 동일한 스타일) --%>
                <div class="gallery-filter" style="margin-bottom: 20px;">
                    <a href="<c:url value='/board/inquiry?game=all' />" class="filter-btn ${currentGame == 'all' ? 'active' : ''}">전체</a>
                    <a href="<c:url value='/board/inquiry?game=battleground' />" class="filter-btn ${currentGame == 'battleground' ? 'active' : ''}">배틀그라운드</a>
                    <a href="<c:url value='/board/inquiry?game=lol' />" class="filter-btn ${currentGame == 'lol' ? 'active' : ''}">리그 오브 레전드</a>
                    <a href="<c:url value='/board/inquiry?game=overwatch' />" class="filter-btn ${currentGame == 'overwatch' ? 'active' : ''}">오버워치</a>
                </div>

                <table class="qna-table">
                    <thead>
                        <tr>
                            <th width="80">번호</th>
                            <th>제목</th>
                            <th width="120">작성자</th>
                            <th width="120">날짜</th>
                            <th width="120">상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%-- 실데이터 출력 시 <c:forEach>를 사용하게 될 부분 --%>
                        <tr>
                            <td>003</td>
                            <td class="title-td">
                                <%-- 전체보기일 때 어떤 게임 문의인지 태그 달아주면 좋음 --%>
                                <c:if test="${currentGame == 'all'}"><small style="color:#3b82f6">[배그]</small> </c:if>
                                로그인 오류가 계속 발생합니다.
                            </td>
                            <td>USER01</td>
                            <td>25-03-09</td>
                            <td><span class="status-badge waiting">답변대기</span></td>
                        </tr>
                        <%-- ... 반복 ... --%>
                    </tbody>
                </table>

                <div class="pagination">
                    <button class="page-btn">이전</button>
                    <button class="page-btn active">1</button>
                    <button class="page-btn">다음</button>
                </div>
            </div>
        </main>

        <aside class="side-right">
            <div class="side-card" style="background: #cbd5e1; min-height: 200px;">
                <h3>문의 안내</h3>
                <p style="font-size: 14px; color: #475569; line-height: 1.7; font-weight: 500;">
                    • 평일: 09:00 ~ 18:00<br>
                    • 주말/공휴일 휴무<br><br>
                    문의하신 내용은 관리자 확인 후 순차적으로 답변드립니다.
                </p>
            </div>
        </aside>
    </div>

    <footer>© 2026 LOG.GG ${displayGameName} 서비스. 모든 권리 보유.</footer>
</body>
</html>