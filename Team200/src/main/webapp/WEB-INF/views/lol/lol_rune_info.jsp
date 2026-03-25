<%@ page session="false" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/lol/style.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/main/style.css">
<script> const contextPath = "${pageContext.request.contextPath}"; </script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/lol/script.js"
	defer></script>
<script
	src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>

<title>롤 룬 정보 - LOG.GG</title>
</head>
<body>
	<c:set var="headerTitle" value="리그 오브 레전드" />
	<%@ include file="../common/header.jsp"%>

	<div class="main-layout">
		<aside class="side-left">
            <%@ include file="../common/sidebar.jsp" %>
        </aside>

		<main>
			<a href="<c:url value='/lol/main'/>"><div class="logo">LOG.GG</div></a>

			<div class="rune-container">
				<div class="rune-visual-section">

					<div class="path-selector" id="main-path-selector">
						<c:forEach var="rune" items="${runeList}">
							<img src="${rune.runeImg}" class="path-icon"
								onclick="loadTalents(${rune.runeNo}, '${rune.runeName}', this)"
								title="${rune.runeName}">
						</c:forEach>
					</div>

					<div class="rune-grid">
						<div class="rune-col" id="primary-rune-col" style="width: 100%;">
							<h5 id="primary-path-name" style="margin-bottom: 20px;">핵심빌드를 선택해주세요</h5>
							
							<div id="primary-slots-container" class="slots-layout"></div>
						</div>
					</div>
				</div>

				<div class="rune-desc-section">
					<div id="desc-name">룬을 선택하세요</div>
					<div class="desc-box">
						<div id="desc-text">좌측에서 특성 아이콘을 클릭하면 상세한 효과와 능력치가 여기에
							표시됩니다.</div>
					</div>
				</div>
			</div>
		</main>

		<aside class="side-right">
			<div class="side-card">
				<h3>최근 업데이트</h3>
				<div style="font-size: 13px; color: #475569; padding: 10px;">
					룬 시스템 밸런스 패치 노트<br> 신규 룬 업데이트 대기 중
				</div>
			</div>
		</aside>
	</div>

	<%@ include file="../common/footer.jsp"%>
</body>
</html>