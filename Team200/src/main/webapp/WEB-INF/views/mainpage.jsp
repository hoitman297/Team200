<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<c:set var="gameId" value="all" />
<c:set var="currentGameName" value="전체" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">    
    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>   
    <title>LOG.GG - 메인페이지</title>
</head>

<body>
    <%@ include file="common/header.jsp" %>

    <div class="main-layout">
        <aside class="side-left">
            <div class="side-card">
                <h3>패치 노트</h3>
                <div class="list-item">2026.03.05 [오버워치]</div>
                <div class="list-item">2026.02.05 [배틀그라운드]</div>
                <div class="list-item">2026.01.15 [롤]</div>
            </div>
        </aside>

        <main class="content-area">
            <div class="top-row">
                <a href="<c:url value='/' />"><div class="logo">LOG.GG</div></a>
            </div>

            <div class="game-cards">
                <div class="card" data-title="LEGAGUE OF LEGENDS"><a href="<c:url value='/lol/main'/>"><img src="${pageContext.request.contextPath}/resources/img/롤.webp" alt="LOL"></a></div>
                <div class="card" data-title="OVERWATCH"><a href="<c:url value='/overwatch/main'/>"><img src="${pageContext.request.contextPath}/resources/img/오버워치.webp" alt="OW"></a></div>
                <div class="card" data-title="BATTLEGROUNDS"><a href="<c:url value='/battleground/main'/>"><img src="${pageContext.request.contextPath}/resources/img/배그.jpg" alt="PUBG"></a></div>
            </div>

            <div class="board-card">
                <div class="tab-menu">
                    <div class="tab-item active">인기 게시글</div>
                    <a href="<c:url value='/lol/main'/>"><div class="tab-item">리그 오브 레전드</div></a>
                    <a href="<c:url value='/overwatch/main'/>"><div class="tab-item">오버워치</div></a>
                    <a href="<c:url value='/battleground/main'/>"><div class="tab-item">배틀그라운드</div></a>
                </div>
                <div class="tab-content">
                    <div class="board-row header-row">
                        <div class="col-likes">공감</div>
                        <div class="col-title">제목</div>
                        <div class="col-author">작성자</div>
                        <div class="col-date">날짜</div>
                    </div>
                    <div class="board-row">
                        <div class="col-likes">150</div>
                        <div class="col-title">LOG.GG 커뮤니티 이용 규칙 필독 가이드</div>
                        <div class="col-author">관리자</div>
                        <div class="col-date">03.01</div>
                    </div>
                </div>
            </div>
        </main>
        
        <aside class="side-right">
            <div class="side-card">
                <h3>공지사항</h3>
                <div class="list-item">공개 테스트 서버 안내</div>
                <div class="list-item">웹사이트 업데이트 내역</div>
            </div>
        </aside>
    </div>

    <%@ include file="common/footer.jsp" %>
</body>
</html>