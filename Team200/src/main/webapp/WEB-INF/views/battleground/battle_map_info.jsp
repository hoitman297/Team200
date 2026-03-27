<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%-- 💖 [핵심 수정] 사이드바와 헤더가 배그 경로를 정확히 인식하도록 최상단 배치! 💖 --%>
<c:set var="gameId" value="battleground" />
<c:set var="currentGameName" value="배틀그라운드" />
<c:set var="headerTitle" value="배틀그라운드" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/battleground/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">

<%-- 외부 라이브러리: Leaflet --%>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/battleground/script.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>

<title>배틀그라운드 지도 정보 - LOG.GG</title>
</head>
<body>
    <%-- 공통 헤더 포함 --%>
    <%@ include file="../common/header.jsp"%>

    <div class="main-layout">
        <aside class="side-left">
            <%-- ✨ 이제 사이드바 게시판 링크가 /board/free_battleground로 정확하게 연결됩니다! ✨ --%>
            <%@ include file="../common/sidebar.jsp" %>
        </aside>

        <main class="content-area">
            <div class="top-row">
                <a href="<c:url value='/battleground/main'/>" style="text-decoration: none;">
                    <div class="logo">LOG.GG</div>
                </a>
            </div>

            <div class="map-container-card">
                <%-- 필터 탭 --%>
                <div class="filter-header">
                    <div class="filter-item active">기본 지도</div>
                    <div class="filter-item">차량 스폰</div>
                    <div class="filter-item">차고 위치</div>
                    <div class="filter-item">선박 위치</div>
                    <div class="filter-item">비밀 방</div>
                </div>

                <%-- 지도 뷰포트 --%>
                <div class="map-viewport" style="background: #1a1a1a; border-radius: 12px; overflow: hidden; border: 1px solid #334155;">
                    <div class="map-canvas" id="canvas" style="width: 100%; height: 600px;">
                        <%-- 지도가 JS로 로드되지 않을 경우를 대비한 기본 이미지 영역 --%>
                        <img id="mapImg" src="" alt="MAP" class="map-image" style="max-width: 100%; display: none;">
                    </div>
                </div>
            </div>
        </main>
    </div>

    <%-- 공통 푸터 포함 --%>
    <%@ include file="../common/footer.jsp"%>

</body>
</html>