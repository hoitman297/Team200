<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="gameId" value="all" />
<c:set var="currentGameName" value="전체" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/main/style.css">

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
<title>LOG.GG - 메인페이지</title>
</head>

<body>
	<%@ include file="common/header.jsp"%>

	<div class="main-layout">
		<aside class="side-left">
			<div class="side-card">
				<h3>패치 노트</h3>
				<div class="list-item">2026.03.05 [오버워치]</div>
				<div class="list-item">2026.02.05 [배틀그라운드]</div>
				<div class="list-item">2026.01.15 [롤]</div>
			</div>
		</aside>

		<main class="content-area">
			<div class="top-row">
				<a href="<c:url value='/' />"><div class="logo">LOG.GG</div></a>
			</div>

			<div class="game-cards">
				<div class="card" data-title="LEAGUE OF LEGENDS">
					<a href="<c:url value='/lol/main'/>"><img
						src="${pageContext.request.contextPath}/resources/img/롤.webp"
						alt="LOL"></a>
				</div>
				<div class="card" data-title="OVERWATCH">
					<a href="<c:url value='/ow/main'/>"><img
						src="${pageContext.request.contextPath}/resources/img/오버워치.webp"
						alt="OW"></a>
				</div>
				<div class="card" data-title="BATTLEGROUNDS">
					<a href="<c:url value='/bg/main'/>"><img
						src="${pageContext.request.contextPath}/resources/img/배그.jpg"
						alt="PUBG"></a>
				</div>
			</div>

			<div class="board-card">
				<div class="tab-menu" style="position: relative;">
				    <div class="tab-item active">인기 게시글</div>
				
				    <div style="position: relative; display: inline-block;" 
				         onmouseenter="this.querySelector('.preview-container').style.display='block'" 
				         onmouseleave="this.querySelector('.preview-container').style.display='none'">
				        
				        <a href="<c:url value='/lol/main' />"><div class="tab-item">리그 오브 레전드</div></a>
				        
				        <div class="preview-container" style="display: none; position: absolute; top: 100%; left: 0; width: 450px; background: white; border-radius: 15px; box-shadow: var(--card-shadow); z-index: 1000; padding: 10px; border: 1px solid #f1f5f9;">
				            <div class="board-row header-row" style="padding: 10px 0; border-bottom: 2px solid #f1f5f9; font-size: 13px;">
				                <div class="col-likes" style="width: 50px;">공감</div>
				                <div class="col-title" style="flex: 1; text-align: left; padding-left: 15px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
								    <a href="<c:url value='/board/view?boardNo=${b.boardNo}' />" style="text-decoration: none; color: inherit; display: block; width: 100%;">
								        ${b.boardTitle}
								        
								        <c:if test="${b.replyCount > 0}">
								            <span style="color: var(--accent-blue); font-weight: 800; font-size: 12px; margin-left: 4px;">[${b.replyCount}]</span>
								        </c:if>
								    </a>
								</div>
				                <div class="col-author" style="width: 80px;">작성자</div>
				                <div class="col-date" style="width: 70px;">날짜</div>
				            </div>
				            <c:forEach var="b" items="${lolBest}">
				                <div class="board-row" style="padding: 10px 0; border-bottom: 1px solid #f8fafc; font-size: 13px;">
				                    <div class="col-likes" style="width: 50px; color: var(--accent-blue); font-weight: bold;">${b.likeCount}</div>
				                    
				                    <div class="col-title" style="flex: 1; text-align: left; padding-left: 15px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
									    <a href="<c:url value='/board/view?boardNo=${b.boardNo}' />" style="text-decoration: none; color: inherit; display: block; width: 100%;">
									        ${b.boardTitle}
									        
									        <c:if test="${b.replyCount > 0}">
									            <span style="color: var(--accent-blue); font-weight: 800; font-size: 12px; margin-left: 4px;">[${b.replyCount}]</span>
									        </c:if>
									    </a>
									</div>
				                    
				                    <div class="col-author" style="width: 80px; color: #64748b;">${b.userName}</div>
				                    <div class="col-date" style="width: 70px; color: #94a3b8; text-align: right;">
				                        <fmt:formatDate value="${b.postDate}" pattern="MM.dd"/>
				                    </div>
				                </div>
				            </c:forEach>
				        </div>
				    </div>
				
				    <div style="position: relative; display: inline-block;" 
				         onmouseenter="this.querySelector('.preview-container').style.display='block'" 
				         onmouseleave="this.querySelector('.preview-container').style.display='none'">
				        
				        <a href="<c:url value='/ow/main' />"><div class="tab-item">오버워치</div></a>
				        
				        <div class="preview-container" style="display: none; position: absolute; top: 100%; left: 0; width: 450px; background: white; border-radius: 15px; box-shadow: var(--card-shadow); z-index: 1000; padding: 10px; border: 1px solid #f1f5f9;">
				            <div class="board-row header-row" style="padding: 10px 0; border-bottom: 2px solid #f1f5f9; font-size: 13px;">
				                <div class="col-likes" style="width: 50px;">공감</div>
				                <div class="col-title" style="flex: 1; text-align: left; padding-left: 15px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
								    <a href="<c:url value='/board/view?boardNo=${b.boardNo}' />" style="text-decoration: none; color: inherit; display: block; width: 100%;">
								        ${b.boardTitle}
								        
								        <c:if test="${b.replyCount > 0}">
								            <span style="color: var(--accent-blue); font-weight: 800; font-size: 12px; margin-left: 4px;">[${b.replyCount}]</span>
								        </c:if>
								    </a>
								</div>
				                <div class="col-author" style="width: 80px;">작성자</div>
				                <div class="col-date" style="width: 70px;">날짜</div>
				            </div>
				            <c:forEach var="b" items="${owBest}">
				                <div class="board-row" style="padding: 10px 0; border-bottom: 1px solid #f8fafc; font-size: 13px;">
				                    <div class="col-likes" style="width: 50px; color: var(--accent-blue); font-weight: bold;">${b.likeCount}</div>
				                    <div class="col-title" style="flex: 1; text-align: left; padding-left: 15px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
									    <a href="<c:url value='/board/view?boardNo=${b.boardNo}' />" style="text-decoration: none; color: inherit; display: block; width: 100%;">
									        ${b.boardTitle}
									        
									        <c:if test="${b.replyCount > 0}">
									            <span style="color: var(--accent-blue); font-weight: 800; font-size: 12px; margin-left: 4px;">[${b.replyCount}]</span>
									        </c:if>
									    </a>
									</div>
				                    <div class="col-author" style="width: 80px; color: #64748b;">${b.userName}</div>
				                    <div class="col-date" style="width: 70px; color: #94a3b8; text-align: right;">
				                        <fmt:formatDate value="${b.postDate}" pattern="MM.dd"/>
				                    </div>
				                </div>
				            </c:forEach>
				        </div>
				    </div>
				
				    <div style="position: relative; display: inline-block;" 
				         onmouseenter="this.querySelector('.preview-container').style.display='block'" 
				         onmouseleave="this.querySelector('.preview-container').style.display='none'">
				        
				        <a href="<c:url value='/bg/main' />"><div class="tab-item">배틀그라운드</div></a>
				        
				        <div class="preview-container" style="display: none; position: absolute; top: 100%; left: 0; width: 450px; background: white; border-radius: 15px; box-shadow: var(--card-shadow); z-index: 1000; padding: 10px; border: 1px solid #f1f5f9;">
				            <div class="board-row header-row" style="padding: 10px 0; border-bottom: 2px solid #f1f5f9; font-size: 13px;">
				                <div class="col-likes" style="width: 50px;">공감</div>
				                <div class="col-title" style="flex: 1; text-align: left; padding-left: 15px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
								    <a href="<c:url value='/board/view?boardNo=${b.boardNo}' />" style="text-decoration: none; color: inherit; display: block; width: 100%;">
								        ${b.boardTitle}
								        
								        <c:if test="${b.replyCount > 0}">
								            <span style="color: var(--accent-blue); font-weight: 800; font-size: 12px; margin-left: 4px;">[${b.replyCount}]</span>
								        </c:if>
								    </a>
								</div>
				                <div class="col-author" style="width: 80px;">작성자</div>
				                <div class="col-daste" style="width: 70px;">날짜</div>
				            </div>
				            <c:forEach var="b" items="${bgBest}">
				                <div class="board-row" style="padding: 10px 0; border-bottom: 1px solid #f8fafc; font-size: 13px;">
				                    <div class="col-likes" style="width: 50px; color: var(--accent-blue); font-weight: bold;">${b.likeCount}</div>
				                    <div class="col-title" style="flex: 1; text-align: left; padding-left: 15px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
									    <a href="<c:url value='/board/view?boardNo=${b.boardNo}' />" style="text-decoration: none; color: inherit; display: block; width: 100%;">
									        ${b.boardTitle}
									        
									        <c:if test="${b.replyCount > 0}">
									            <span style="color: var(--accent-blue); font-weight: 800; font-size: 12px; margin-left: 4px;">[${b.replyCount}]</span>
									        </c:if>
									    </a>
									</div>
				                    <div class="col-author" style="width: 80px; color: #64748b;">${b.userName}</div>
				                    <div class="col-date" style="width: 70px; color: #94a3b8; text-align: right;">
				                        <fmt:formatDate value="${b.postDate}" pattern="MM.dd"/>
				                    </div>
				                </div>
				            </c:forEach>
				        </div>
				    </div>
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
							<div class="board-row"
								style="justify-content: center; color: #94a3b8;">인기 게시글이
								없습니다.</div>
						</c:when>
						<c:otherwise>
							<c:forEach var="best" items="${bestList}">
								<div class="board-row">
									<div class="col-likes">${best.likeCount}</div>

									<div class="col-title" style="flex: 1; text-align: left; padding-left: 15px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
									    <a href="<c:url value='/board/view?boardNo=${best.boardNo}' />" style="text-decoration: none; color: inherit; display: block; width: 100%;">
									        
<!-- 									        <span style="color: var(--accent-blue); font-weight: 800; font-size: 12px; margin-left: 4px;"> -->
<%-- 									            [${best.gameCode == 'LOL' ? '롤' : (best.gameCode == 'OW' ? '옵치' : '배그')}] --%>
<!-- 									        </span> -->
									
									        <span style="font-weight: 500;">${best.boardTitle}</span>
									        
									        <c:if test="${best.replyCount > 0}">
									            <span style="color: var(--accent-blue); font-weight: 800; font-size: 12px; margin-left: 4px;">[${best.replyCount}]</span>
									        </c:if>
									    </a>
									</div>

									<div class="col-author">${best.userName}</div>

									<div class="col-date">
										<fmt:formatDate value="${best.postDate}" pattern="MM.dd" />
									</div>
								</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</main>

		<aside class="side-right">
			<div class="side-card">
				<h3>공지사항</h3>
				<div class="list-item">공개 테스트 서버 안내</div>
				<div class="list-item">웹사이트 업데이트 내역</div>
			</div>
		</aside>
	</div>

	<%@ include file="common/footer.jsp"%>
</body>
</html>