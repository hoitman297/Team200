<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/battleground/style.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/main/style.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/battleground/script.js"
	defer></script>
<script
	src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
<link rel="stylesheet"
	href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<title>배틀그라운드</title>
</head>
<body>
	<c:set var="headerTitle" value="배틀그라운드" />
	<%@ include file="../common/header.jsp"%>


	<div class="main-layout">
		<aside class="side-left">
			<div class="side-card">
				<h3>전장 선택</h3>
				<button class="map-btn active">에란겔 (Erangel)</button>
				<button class="map-btn">미라마 (Miramar)</button>
				<button class="map-btn">사녹 (Sanhok)</button>
				<button class="map-btn">비켄디 (Vikendi)</button>
				<button class="map-btn">테이고 (Taego)</button>
				<button class="map-btn">론도 (Rondo)</button>
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