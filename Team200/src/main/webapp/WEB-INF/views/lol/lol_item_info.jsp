<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

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

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/lol/script.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/search/script.js" defer></script>
<title>롤 아이템 정보 - LOG.GG</title>
</head>
<body>
	<%@ include file="../common/header.jsp"%>

	<div class="main-layout">
		<aside class="side-left">
			<%@ include file="../common/sidebar.jsp" %>
		</aside>

		<main class="content-area">
			<div class="top-row">
				<a href="<c:url value ='/lol/main'/>" style="text-decoration: none;">
					<div class="logo">LOG.GG</div>
				</a>
				<div class="search-bar">
					<input type="text" id="itemSearchInput" class="search-input-field" placeholder="아이템 이름 또는 태그 검색"> 
					<span style="cursor:pointer">🔍</span>
				</div>
			</div>

			<div class="item-card">
				<div class="item-categories">
					<div class="category-btn"><div class="category-icon"></div><span>전사</span></div>
					<div class="category-btn"><div class="category-icon"></div><span>원거리 딜러</span></div>
					<div class="category-btn"><div class="category-icon"></div><span>암살자</span></div>
					<div class="category-btn"><div class="category-icon"></div><span>마법사</span></div>
					<div class="category-btn"><div class="category-icon"></div><span>탱커</span></div>
					<div class="category-btn"><div class="category-icon"></div><span>서포터</span></div>
				</div>

				<div class="item-table-container">
					<%-- ✨ [추가] 테이블 상단 페이지 컨트롤러 ✨ --%>
					<div class="table-controls" style="display: flex; justify-content: flex-end; align-items: center; gap: 10px; margin-bottom: 10px;">
						<span style="font-size: 14px; font-weight: bold;">
							<span id="currentPage">1</span> / <span id="totalPage">1</span>
						</span>
						<button id="prevBtn" class="page-nav-btn">◀</button>
						<button id="nextBtn" class="page-nav-btn">▶</button>
					</div>

					<table class="item-table">
						<thead>
							<tr>
								<th class="icon" style="width: 80px;">아이콘</th>
								<th class="name-price" style="width: 150px;">이름</th>
								<th class="name-price" style="width: 100px;">가격</th>
							</tr>
						</thead>
						<tbody id="itemTableBody">
							<c:forEach var="item" items="${itemList}">
								<tr class="item-row" data-tags="${item.itemTag}" data-info="${item.itemInfo}" data-name="${item.itemName}">
									<td>
										<div class="item-img-placeholder" style="background: none;">
											<img src="${item.itemImg}" alt="${item.itemName}"
												style="width: 48px; height: 48px; border-radius: 5px;">
										</div>
									</td>
									<td class="item-name-cell" style="font-weight: bold;">${item.itemName}</td>
									<td class="name-price" style="color: #eab308;">${item.itemPrice}G</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</main>

		<aside class="side-right">
			<div class="side-card" style="background: #cbd5e1; height: 300px; padding: 20px; border-radius: 12px;">
				<h3 style="margin-bottom: 15px;">아이템 소식</h3>
				<div style="font-size: 14px; color: #475569; line-height: 1.8;">
					시즌 14 대응 아이템 밸런스 조정안이 적용되었습니다.
				</div>
			</div>
		</aside>
	</div>

	<%@ include file="../common/footer.jsp"%>
	<div id="item-tooltip" style="display:none; position:absolute; z-index:9999;"></div>

</body>
</html>