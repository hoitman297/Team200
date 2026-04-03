<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<%-- 💖 사이드바와 헤더가 길을 잃지 않도록 선언 💖 --%>
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

<title>리그 오브 레전드 - LOG.GG</title>
</head>

<body>
	<%@ include file="../common/header.jsp"%>

	<div class="main-layout">
		<aside class="side-left">
			<%@ include file="../common/sidebar.jsp"%>
		</aside>

		<main class="content-area">
			<div class="top-row">
				<a href="<c:url value='/lol/main'/>"><div class="logo">LOG.GG</div></a>
			</div>

			<div class="board-card">
				<div class="tab-menu">
					<div class="tab-item active">실시간 인기글</div>
					<a href="<c:url value ='/lol/hero_main'/>">
						<div class="tab-item">챔피언정보</div>
					</a> 
					<a href="<c:url value ='/lol/rune'/>">
						<div class="tab-item">룬</div>
					</a> 
					<a href="<c:url value ='/lol/item'/>">
						<div class="tab-item">아이템</div>
					</a> 
					<a href="<c:url value ='/lol/box'/>">
						<div class="tab-item">상자 시뮬레이터</div>
					</a>
				</div>

				<div class="tab-content">
					<div class="board-row header-row">
						<div class="col-likes">공감</div>
						<div class="col-title">제목</div>
						<div class="col-author">작성자</div>
						<div class="col-date">날짜</div>
					</div>
					<c:choose>
						<c:when test="${empty bestList}">
							<div class="board-row" style="justify-content: center; color: #94a3b8;">
								인기 게시글이 없습니다.
							</div>
						</c:when>
						<c:otherwise>
							<c:forEach var="best" items="${bestList}">
								<div class="board-row">
									<div class="col-likes">
										${best.likeCount}
									</div>
									
									<div class="col-title">
										<a href="<c:url value='/board/view?boardNo=${best.boardNo}' />" style="text-decoration: none; color: inherit; vertical-align: middle;">
											<span style="color: var(--accent-blue); font-weight: 800; margin-right: 6px; font-size: 14px;">
												<c:choose>
													<c:when test="${best.categoryName == '자유게시판'}">[자유]</c:when>
													<c:when test="${best.categoryName == '공략게시판'}">[공략]</c:when>
													<c:when test="${best.categoryName == '갤러리'}">[갤러리]</c:when>
													<c:otherwise>[기타]</c:otherwise> 
												</c:choose>
											</span>
											${best.boardTitle}
											
											<c:if test="${best.replyCount > 0}">
												<span style="color: var(--accent-blue); font-weight: 800; font-size: 12px; margin-left: 4px;">[${best.replyCount}]</span>
											</c:if>
										</a>
									</div>
									
									<div class="col-author">
										${best.userName}
									</div>
									
									<div class="col-date">
										<fmt:formatDate value="${best.postDate}" pattern="MM.dd"/>
									</div>
								</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</div>
			</div>

			<div class="bottom-grid">
				<div class="grid-box" style="grid-column: 1 / -1;">
					<h4 style="margin: 0 0 15px 0;">갤러리</h4>
					
					<div style="display: flex; justify-content: space-between; align-items: flex-end;">
						
						<%-- ✨ [수정] flex: 1과 justify-content: center로 중앙 정렬, gap: 25px로 간격 조정 --%>
						<div class="thumb-container" style="display: flex; gap: 25px; flex-wrap: wrap; flex: 1; justify-content: center;">
							<c:forEach var="gal" items="${recentGallery}">
								<a href="<c:url value='/board/view?boardNo=${gal.boardNo}'/>" style="text-decoration: none; display: block;">
									<div class="thumb" style="width: 140px; height: 140px; border-radius: 12px; overflow: hidden; background: #e2e8f0;">
										<c:choose>
											<c:when test="${not empty gal.thumbnail}">
												<img src="<c:url value='/resources/upload/board/${gal.thumbnail}'/>" alt="갤러리 썸네일" style="width: 100%; height: 100%; object-fit: cover; transition: transform 0.2s ease;">
											</c:when>
											<c:otherwise>
												<img src="<c:url value='/resources/images/no_image.png'/>" alt="no-image" style="width: 100%; height: 100%; object-fit: contain; padding: 20px; box-sizing: border-box;">
											</c:otherwise>
										</c:choose>
									</div>
								</a>
							</c:forEach>

							<c:forEach begin="${empty recentGallery ? 0 : fn:length(recentGallery)}" end="3">
								<div class="thumb" style="width: 140px; height: 140px; border-radius: 12px; background: #f1f5f9; display: flex; align-items: center; justify-content: center; color: #94a3b8; font-size: 13px; font-weight: 500; border: 1px dashed #cbd5e1; box-sizing: border-box;">
									비어있음
								</div>
							</c:forEach>
						</div>

						<div style="padding-left: 15px; padding-bottom: 5px;">
							<a href="<c:url value='/gallery/list?gameCode=LOL'/>" style="font-size: 13px; color: #64748b; text-decoration: none; font-weight: 600;">더보기 &gt;</a>
						</div>

					</div>
				</div>
			</div>
		</main>

		<aside class="sidebar-right">
			<h3>최근 업데이트</h3>
			<div style="font-size: 14px; color: #475569; line-height: 1.8;">
				최신 업데이트 내용을 확인하세요.</div>
		</aside>
	</div>

	<%@ include file="../common/footer.jsp"%>
</body>
</html>