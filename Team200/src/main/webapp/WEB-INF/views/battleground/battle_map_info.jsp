<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/battleground/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/battleground/script.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

<title>배틀그라운드</title>
</head>
<body>
	<c:set var="headerTitle" value="배틀그라운드" />
	<%@ include file="../common/header.jsp"%>


	<div class="main-layout">
		<aside class="side-left">
            <div class="side-card">
                <h3>카테고리</h3>
                <a href="<c:url value = '/gallery/list' />"><div class="menu-item">갤러리</div></a>
                
                <div class="menu-item-group">
                    <div class="menu-item">게시판</div>
                    <div class="sub-menu-container">
                        <a href="<c:url value = '/board/free_battleground' />"><div class="sub-item">자유게시판</div></a>
                        <a href="<c:url value = '/board/strategy_battleground' />"><div class="sub-item">공략게시판</div></a>
                    </div>
                </div>
                
                <a href="<c:url value = '/board/inquiry' />"><div class="menu-item">고객지원</div></a>
            </div>
        </aside>

		<main class="content-area">
			<a href="<c:url value ='/battleground/main'/>"><div class="logo">LOG.GG</div></a>


			<div class="map-container-card">
				<div class="filter-header">
					<div class="filter-item active">기본 지도</div>
					<div class="filter-item">차량 스폰</div>
					<div class="filter-item">차고 위치</div>
					<div class="filter-item">선박 위치</div>
					<div class="filter-item">비밀 방</div>
				</div>

				<div class="map-viewport">
					<div class="map-canvas" id="canvas">
						<img id="mapImg" src="" alt="MAP" class="map-image">
					</div>
				</div>
			</div>
		</main>
	</div>

	<%@ include file="../common/footer.jsp"%>

</body>
</html>