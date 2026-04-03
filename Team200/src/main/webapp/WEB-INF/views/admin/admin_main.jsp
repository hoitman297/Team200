<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/admin/admin_main/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    <script src="${pageContext.request.contextPath}/resources/admin/admin_main/script.js"></script>
	<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
	
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <title>LOG.GG - 통합 게임 플랫폼</title>
    <%@ include file="../common/header.jsp"%>
</head>
<body>

    <div class="container">
        <aside class="main-side">
            <div class="side-card">
                <h3>게임별 패치노트 <button class="btn-mini">
                 <a href="<c:url value = '/admin/patchnote'/>">패치노트 등록</a></button></h3>
                <ul class="patch-list">
                    <c:choose>
                        <c:when test="${empty patchList}">
                            <li>패치노트 데이터가 없습니다.</li>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="patch" items="${patchList}">
                                <%-- 클릭 시 해당 패치노트 상세 페이지로 이동 --%>
                                <li onclick="location.href='<c:url value='/board/patchnoteView?boardNo=${patch.boardNo}'/>'" style="cursor:pointer;">
                                    <strong>
                                        <c:choose>
                                            <c:when test="${patch.gameCode == 'LOL'}">리그 오브 레전드</c:when>
                                            <c:when test="${patch.gameCode == 'OW'}">오버워치</c:when>
                                            <c:otherwise>배틀그라운드</c:otherwise>
                                        </c:choose>
                                    </strong>
                                    <span><fmt:formatDate value="${patch.postDate}" pattern="yyyy.MM.dd"/></span>
                                </li>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </aside>

        <main class="main-content">
			<a href="<c:url value='/' />">
                <div class="logo">LOG.GG</div>
            </a>
            <div class="content-card">
                <nav class="tab-nav">
                    <button class="tab-btn active" onclick="openTab(event, 'tab-board')">관리자 페이지</button>
                    <button class="tab-btn" onclick="location.href='<c:url value='/admin/user_management' />'">회원관리</button>
                    <button class="tab-btn" onclick="location.href='<c:url value='/admin/inquiry' />'">고객지원</button>
                    <button class="tab-btn" onclick="location.href='<c:url value='/admin/user_report'/>'">신고내역</button>
                </nav>

                <div id="tab-board" class="tab-pane active">
                    <table class="board-table">
                      
                            	<p style="font-weight:700">관리자 전용 페이지입니다. 각 탭 별로 누를시 이동합니다</p> 
                               
                    </table>
                    
                    <div style="margin:40px 0 15px 0; display: flex; justify-content: space-between; align-items: flex-end;">
                    </div>
                    <div class="footer-visual">
                    </div>
                </div>

        </main>

        <aside class="main-side">
            <div class="side-card" style="background:#cbd5e1">
                <h3 style="border-color: #475569;">공지사항 
                <button class="btn-mini" style="background:#fff">
                <a href="<c:url value = '/admin/notice'/>">공지 등록</a></button>
                </h3>
                <ul class="patch-list">
                    <c:choose>
                        <c:when test="${empty noticeList}">
                            <li style="border-color: #94a3b8;">등록된 공지가 없습니다.</li>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="notice" items="${noticeList}">
                                <%-- 클릭 시 해당 공지사항 상세 페이지로 이동 --%>
                                <li style="border-color: #94a3b8; cursor:pointer;" 
                                    onclick="location.href='<c:url value='/board/noticeView?boardNo=${notice.boardNo}'/>'">
                                    <div style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap; max-width:150px;" title="${notice.boardTitle}">
                                        ${notice.boardTitle}
                                    </div>
                                    <span><fmt:formatDate value="${notice.postDate}" pattern="MM.dd"/></span>
                                </li>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </aside>
    </div>
    
   

    <footer>© 2026 LOG.GG 게임 커뮤니티 플랫폼. 모든 권리 보유.</footer>
</body>
</html>