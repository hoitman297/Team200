<%@ page session="false" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<title>배틀그라운드</title>
</head>
<body>
	<c:set var="headerTitle" value="배틀그라운드" />
	<%@ include file="../common/header.jsp"%>


	<div class="main-layout">
		<aside class="side-left">
			<div class="side-card">
				<h3>카테고리</h3>
				<div class="menu-item">갤러리</div>
				<div class="menu-item">커뮤니티</div>
				<div class="sub-item">자유게시판</div>
				<div class="sub-item">공략게시판</div>
				<div class="menu-item">아이템 정보</div>
				<div class="sub-item">무기</div>
				<div class="sub-item">차량</div>
				<div class="menu-item">미디어</div>
				<div class="menu-item">1:1 문의</div>
			</div>
		</aside>

		<main class="content-area">
			<a href="<c:url value ='/battleground/main'/>"><div class="logo">LOG.GG</div></a>

			<div class="item-card">
				<div class="item-categories">
					<div class="category-btn">
						<div class="category-icon"></div>
						<span>무기</span>
					</div>
					<div class="category-btn">
						<div class="category-icon"></div>
						<span>부착물</span>
					</div>
					<div class="category-btn">
						<div class="category-icon"></div>
						<span>탄약</span>
					</div>
					<div class="category-btn">
						<div class="category-icon"></div>
						<span>방어구</span>
					</div>
					<div class="category-btn">
						<div class="category-icon"></div>
						<span>소모품</span>
					</div>
					<div class="category-btn">
						<div class="category-icon"></div>
						<span>탈 것</span>
					</div>
				</div>

				<div class="item-table-container">
					<table class="item-table">
						<thead>
							<tr>
								<th>아이콘</th>
								<th>이름</th>
								<th>종류</th>
								<th>데미지</th>
								<th>장탄수</th>
								<th>탄약</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>
									<div class="item-img-placeholder"></div>
								</td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
							</tr>
							<tr>
								<td>
									<div class="item-img-placeholder"></div>
								</td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
							</tr>
							<tr>
								<td>
									<div class="item-img-placeholder"></div>
								</td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
							</tr>
							<tr>
								<td>
									<div class="item-img-placeholder"></div>
								</td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
							</tr>
							<tr>
								<td>
									<div class="item-img-placeholder"></div>
								</td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
							</tr>
						</tbody>
					</table>

					<div class="pagination">
						<button class="page-btn">← 이전</button>
						<button class="page-btn">다음 →</button>
					</div>
				</div>
			</div>
		</main>

		<aside class="side-right">
			<div class="side-card" style="background: #cbd5e1; height: 300px;">
				<h3>최근 업데이트</h3>
			</div>
		</aside>
	</div>

	<%@ include file="../common/footer.jsp"%>

</body>
</html>