<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%-- 💖 [핵심 수정] 사이드바와 헤더가 'battleground' 경로를 인식하도록 최상단 배치! 💖 --%>
<c:set var="gameId" value="battleground" />
<c:set var="currentGameName" value="배틀그라운드" />
<c:set var="headerTitle" value="배틀그라운드" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/battleground/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/battleground/script.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>

<title>배틀그라운드 아이템 정보 - LOG.GG</title>
</head>
<body> 
	<%-- 공통 헤더 포함 --%>
	<%@ include file="../common/header.jsp"%>

	<div class="main-layout">
		<aside class="side-left">
			<%-- ✨ 이제 사이드바 게시판 링크가 /board/free_battleground로 정확하게 연결됩니다! ✨ --%>
			<%@ include file="../common/sidebar.jsp" %>
		</aside>

		<main class="content-area">
			<div class="top-row">
				<a href="<c:url value ='/bg/main'/>"><div class="logo">LOG.GG</div></a>
			</div>

			<div class="item-card">
				<div class="item-categories">
					<div class="category-btn"><div class="category-icon"></div><span>무기</span></div>
					<div class="category-btn"><div class="category-icon"></div><span>부착물</span></div>
					<div class="category-btn"><div class="category-icon"></div><span>탄약</span></div>
					<div class="category-btn"><div class="category-icon"></div><span>방어구</span></div>
					<div class="category-btn"><div class="category-icon"></div><span>소모품</span></div>
					<div class="category-btn"><div class="category-icon"></div><span>탈 것</span></div>
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
							<%-- 실제 데이터 연동 시 c:forEach를 사용하세요 --%>
							<c:forEach var="i" begin="1" end="5">
							<tr>
								<td><div class="item-img-placeholder"></div></td>
								<td>아이템 이름</td>
								<td>종류</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
							</tr>
							</c:forEach>
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
			<div class="side-card" style="background: #cbd5e1; min-height: 300px; padding: 20px; border-radius: 12px;">
				<h3 style="font-size: 16px; margin-bottom: 15px;">아이템 소식</h3>
				<div style="font-size: 14px; color: #475569; line-height: 1.8;">
					최신 패치에서 조정된 무기 데미지 수치를 확인하세요!
				</div>
			</div>
		</aside>
	</div>

	<%-- 공통 푸터 포함 --%>
	<%@ include file="../common/footer.jsp"%>

</body>
</html>