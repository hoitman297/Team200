<%@ page session="false" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/overwatch/style.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/main/style.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/box/style.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/overwatch/script.js"
	defer></script>
<script
	src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/box/script.js"
	defer></script>
<title>오버워치</title>
</head>
<body>
	<c:set var="headerTitle" value="오버워치" />
	<%@ include file="../common/header.jsp"%>
	<div class="main-layout">
		<aside class="side-left">
			<div class="side-card">
				<h3>카테고리</h3>
				<div class="menu-item">갤러리</div>
				<div class="menu-item">게시판</div>
				<div class="sub-item active">자유 게시판</div>
				<div class="sub-item">공략 게시판</div>
				<div class="menu-item">1:1 문의</div>
			</div>
		</aside>

		<main class="content-area">
			<a href="<c:url value ='/lol/main'/>"><div class="logo">LOG.GG</div></a>

			<div class="sim-container">
				<div id="display" class="result-screen">준비 완료!</div>

				<div class="control-panel">
					<div class="button-group">
						<button class="btn-pull" onclick="gacha(1)">1회 뽑기</button>
						<button class="btn-pull" onclick="gacha(10)">10회 뽑기</button>
					</div>
					<button class="btn-reset" onclick="resetStats()">초기화</button>
				</div>

				<div class="stats-panel">
					<div class="stats-title">
						뽑기 결과 / 뽑기 횟수 : <span id="total">0</span>번
					</div>
					<div class="stat-row grade-s">
						<span>S 등급 (2%)</span> <span id="s-count">0</span>
					</div>
					<div class="stat-row grade-a">
						<span>A 등급 (13%)</span> <span id="a-count">0</span>
					</div>
					<div class="stat-row">
						<span>B 등급 (85%)</span> <span id="b-count">0</span>
					</div>
				</div>
			</div>
		</main>

		<aside class="sidebar-right"
			style="background: #cbd5e1; border-radius: 20px; padding: 25px; height: fit-content;">
			<h3 style="font-size: 16px; margin: 0 0 20px 0; font-weight: 800;">최신
				소식</h3>
			<div style="font-size: 14px; color: #475569; line-height: 1.8;">
				본 시뮬레이션은 재미를 위해 제작되었습니다. 실제 게임의 확률과 다를 수 있습니다.</div>
		</aside>
	</div>
	<%@ include file="../common/footer.jsp"%>

</body>
</html>