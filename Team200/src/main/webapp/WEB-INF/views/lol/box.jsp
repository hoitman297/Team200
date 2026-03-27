<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%-- 💖 [핵심 수정] 사이드바와 헤더가 'lol' 경로를 완벽하게 인식하도록 설정 💖 --%>
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
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/box/style.css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/lol/script.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/box/script.js" defer></script>

<title>롤 마법공학 상자 시뮬레이터 - LOG.GG</title>
</head>
<body>
	<%-- 공통 헤더 포함 --%>
	<%@ include file="../common/header.jsp"%>

	<div class="main-layout">
		<aside class="side-left">
			<%-- ✨ 이제 게시판 링크가 /board/free_lol 등으로 정상 작동합니다! ✨ --%>
			<%@ include file="../common/sidebar.jsp" %>
		</aside>

		<main class="content-area">
			<div class="top-row">
				<a href="<c:url value ='/lol/main'/>" style="text-decoration: none;">
					<div class="logo">LOG.GG</div>
				</a>
			</div>

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
						<span>S 등급 (마법공학 희귀템)</span> <span id="s-count">0</span>
					</div>
					<div class="stat-row grade-a">
						<span>A 등급 (서사급 이상)</span> <span id="a-count">0</span>
					</div>
					<div class="stat-row">
						<span>B 등급 (일반 스킨/파편)</span> <span id="b-count">0</span>
					</div>
				</div>
			</div>
		</main>

		<aside class="sidebar-right"
			style="background: #cbd5e1; border-radius: 20px; padding: 25px; height: fit-content;">
			<h3 style="font-size: 16px; margin: 0 0 20px 0; font-weight: 800;">시뮬레이터 안내</h3>
			<div style="font-size: 14px; color: #475569; line-height: 1.8;">
				본 시뮬레이션은 재미를 위해 제작되었습니다. <br>실제 마법공학 상자의 확률과 다를 수 있습니다.
			</div>
		</aside>
	</div>

	<%-- 공통 푸터 포함 --%>
	<%@ include file="../common/footer.jsp"%>

</body>
</html>