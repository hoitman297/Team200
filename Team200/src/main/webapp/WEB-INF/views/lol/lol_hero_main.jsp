<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%-- 💖 [핵심 수정] 사이드바와 헤더가 'lol' 경로를 인식하도록 최상단에 배치! 💖 --%>
<c:set var="gameId" value="lol" />
<c:set var="currentGameName" value="리그 오브 레전드" />
<c:set var="headerTitle" value="리그 오브 레전드" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/lol/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">

<%-- 💖 검색창 전용 스타일 추가 💖 --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/search/style.css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/lol/script.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>

<%-- 💖 공통 검색 스크립트 (v1.3) 추가 💖 --%>
<script src="${pageContext.request.contextPath}/resources/search/script.js?v=1.3" defer></script>

<title>롤 챔피언 정보 - LOG.GG</title>
</head>
<body>
    <%-- 공통 헤더 포함 --%>
    <%@ include file="../common/header.jsp"%>

    <div class="main-layout">
        <aside class="side-left">
            <%@ include file="../common/sidebar.jsp" %>
        </aside>

        <main class="content-area">
            <div class="top-row">
                <a href="<c:url value='/lol/main'/>" style="text-decoration: none;">
                    <div class="logo">LOG.GG</div>
                </a>
                
                <%-- 💖 [수정] 공통 검색창 호출 (searchType을 hero로 설정하면 챔피언 검색 가능) 💖 --%>
                <c:set var="searchType" value="hero" />
                <%@ include file="../common/search_bar.jsp" %>
            </div>

            <div class="board-card">
                <div class="champ-grid-container" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(100px, 1fr)); gap: 15px; padding: 20px;">
                    <c:forEach var="champ" items="${champList}">
                        <%-- 💖 [중요] 필터링을 위해 'hero-item' 클래스 추가 💖 --%>
                        <a href="<c:url value='/lol/hero_main/hero_info?champNo=${champ.champNo}'/>" 
                           class="hero-item" 
                           style="text-decoration: none; color: inherit;">
                            <div class="champ-item" style="text-align: center;">
                                <div class="champ-img-box">
                                    <img src="${champ.champImg}" alt="${champ.champName}" 
                                         style="width: 80px; height: 80px; border-radius: 12px; object-fit: cover;" loading="lazy">
                                </div>
                                <%-- 💖 [중요] 필터링 대상이 될 'hero-name' 클래스 추가 💖 --%>
                                <div class="champ-name hero-name" style="margin-top: 8px; font-size: 14px; font-weight: 600;">
                                    <c:out value="${champ.champName}" />
                                </div>
                            </div>
                        </a>
                    </c:forEach>

                    <c:if test="${empty champList}">
                        <div style="grid-column: 1/-1; text-align: center; padding: 50px; color: #94a3b8;">
                            등록된 챔피언이 없습니다.
                        </div>
                    </c:if>
                </div>
            </div>
        </main>

        <aside class="side-right">
            <div class="side-card" style="background: #e2e8f0; min-height: 300px; padding: 20px; border-radius: 12px;">
                <h3 style="font-size: 16px; margin-bottom: 15px;">최근 업데이트</h3>
                <div style="font-size: 13px; color: #475569; line-height: 1.6;">
                    현재 서버에 챔피언 데이터를 동기화 중입니다.<br> 
                    (최신 패치 버전 적용 완료)
                </div>
            </div>
        </aside>
    </div>

    <%-- 공통 푸터 포함 --%>
    <%@ include file="../common/footer.jsp"%>
</body>
</html>