<%@ page session="false" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/overwatch/style.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/main/style.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/overwatch/script.js"
	defer></script>
<script
	src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
<title>오버워치 - LOG.GG</title>
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
				<div class="sub-item">자유게시판</div>
				<div class="sub-item">공략게시판</div>
			</div>
		</aside>

		<main class="content-area">
			<div class="top-row">
				<a href="<c:url value='/overwatch/main'/>" style="text-decoration: none;">
					<div class="logo">LOG.GG</div>
				</a>
				<div class="search-bar">
					<input type="text" placeholder="영웅 검색"> <span>🔍</span>
				</div>
			</div>

			<div class="board-card">
				<div class="hero-grid-container">
					<div class="hero-grid">
						<c:forEach var="hero" items="${heroList}">
							<a href="${pageContext.request.contextPath}/overwatch/hero_main/hero_info?heroNo=${hero.heroNo}"
								class="hero-card"> <img src="${hero.heroImg}"
								alt="${hero.heroName}" class="hero-img">
								<h4>${hero.heroName}</h4>
								<p style="font-size: 12px; color: gray;">${hero.heroPosition}</p>
							</a>
						</c:forEach>
					</div>
				</div>
			</div>
		</main>

		<aside class="side-right">
			<div class="side-card" style="background: #e2e8f0; height: 300px;">
				<h3>최근 업데이트</h3>
				<div
					style="font-size: 13px; color: #475569; line-height: 1.6; margin-top: 10px;">
					현재 서버에 챔피언 데이터를 동기화 중입니다.<br> (최신 패치 버전 적용 완료)
				</div>
			</div>
		</aside>
	</div>

	<%@ include file="../common/footer.jsp"%>
</body>
</html>