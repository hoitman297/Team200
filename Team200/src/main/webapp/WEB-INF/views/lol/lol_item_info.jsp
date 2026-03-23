<%@ page session="false" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/lol/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/lol/script.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>

<title>롤</title>
</head>
<body>
	<c:set var="headerTitle" value="롤" />
	<%@ include file="../common/header.jsp"%>


	<div class="main-layout">
		<aside class="side-left">
			<div class="side-card">
				<h3>카테고리</h3>
				<div class="menu-item">갤러리</div>
				<div class="menu-item">게시판</div>
				<div class="sub-item">자유게시판</div>
				<div class="sub-item">공략게시판</div>
				<div class="menu-item">미디어</div>
				<div class="menu-item">1:1 문의</div>
			</div>
		</aside>

		<main class="content-area">
			<div class="top-row">
				<a href="<c:url value ='/lol/main'/>"><div class="logo">LOG.GG</div></a>
				<div class="search-bar">
					<input type="text" placeholder="아이템검색 검색"> <span>🔍</span>
				</div>
			</div>

			<div class="item-card">
				<div class="item-categories">
					<div class="category-btn">
						<div class="category-icon"></div>
						<span>전사</span>
					</div>
					<div class="category-btn">
						<div class="category-icon"></div>
						<span>원거리 딜러</span>
					</div>
					<div class="category-btn">
						<div class="category-icon"></div>
						<span>암살자</span>
					</div>
					<div class="category-btn">
						<div class="category-icon"></div>
						<span>마법사</span>
					</div>
					<div class="category-btn">
						<div class="category-icon"></div>
						<span>탱커</span>
					</div>
					<div class="category-btn">
						<div class="category-icon"></div>
						<span>서포터</span>
					</div>
				</div>

				<div class="item-table-container">
					<table class="item-table">
						<thead>
							<tr>
								<th class="icon">아이콘</th>
								<th class="name-price">이름</th>
								<th class="name-price">가격</th>
								<th>설명</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><div class="item-img-placeholder"></div></td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
							</tr>
							<tr>
								<td><div class="item-img-placeholder"></div></td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
							</tr>
							<tr>
								<td><div class="item-img-placeholder"></div></td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
							</tr>
							<tr>
								<td><div class="item-img-placeholder"></div></td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
							</tr>
							<tr>
								<td><div class="item-img-placeholder"></div></td>
								<td>text</td>
								<td>text</td>
								<td>text</td>
							</tr>
							<tr>
								<td><div class="item-img-placeholder"></div></td>
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
				<div style="font-size: 14px; color: #475569; line-height: 1.8;">
					최신 업데이트 내용을 확인하세요.</div>
			</div>
		</aside>
	</div>

	<%@ include file="../common/footer.jsp"%>

</body>
</html>