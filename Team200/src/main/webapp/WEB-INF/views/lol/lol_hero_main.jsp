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
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/lol/script.js"
	defer></script>
<script
	src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
<title>롤 - LOG.GG</title>
</head>
<body>
	<c:set var="headerTitle" value="리그 오브 레전드" />
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
				<div class="search-bar">
					<input type="text" placeholder="챔피언 검색"> <span>🔍</span>
				</div>
			</div>

			<div class="board-card">
				<div class="champ-grid-container">
					<c:forEach var="champ" items="${champList}">
						<a href="<c:url value='/lol/hero_main/hero_info?champNo=${champ.champNo}'/>">
							<div class="champ-item">
								<div class="champ-img-box">
									<img src="${champ.champImg}" alt="${champ.champName}"
										loading="lazy">
								</div>
								<div class="champ-name">
									<c:out value="${champ.champName}" />
								</div>
							</div>
						</a>
					</c:forEach>

					<c:if test="${empty champList}">
						<div
							style="grid-column: 1/-1; text-align: center; padding: 50px; color: #94a3b8;">
							등록된 챔피언이 없습니다.</div>
					</c:if>
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