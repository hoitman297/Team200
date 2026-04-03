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
				<h3>패치 노트<button class="btn-mini" style="background:#fff">
                <a href="<c:url value = '/board/patchnote'/>">목록</a></button></h3>
				
				<c:choose>
            <c:when test="${empty patchList}">
                <div class="list-item" style="color: #94a3b8;">데이터가 없습니다.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="patch" items="${patchList}">
                    <%-- 클릭 시 해당 패치노트 상세보기로 이동 --%>
                    <div class="list-item" style="cursor:pointer;" 
                         onclick="location.href='<c:url value='/board/patchnoteView?boardNo=${patch.boardNo}'/>'">
                        <fmt:formatDate value="${patch.postDate}" pattern="yyyy.MM.dd"/> 
                        [${patch.gameCode == 'LOL' ? '롤' : (patch.gameCode == 'OW' ? '오버워치' : '배틀그라운드')}]
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
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

                <div class="tab-menu">

                    <div class="tab-item active">인기 게시글</div>

                    <a href="<c:url value = '/lol/main' />"><div class="tab-item">리그 오브 레전드</div></a>

                    <a href="<c:url value = '/ow/main' />"><div class="tab-item">오버워치</div></a>

                    <a href="<c:url value = '/bg/main' />"><div class="tab-item">배틀그라운드</div></a>

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

									<div class="col-title">
									    <a href="<c:url value='/board/view?boardNo=${best.boardNo}' />" style="text-decoration: none; color: inherit; display: block; width: 100%;">
									        
									        <span style="color: var(--accent-blue); font-weight: 800; font-size: 12px;">
									            [${best.gameCode == 'LOL' ? '롤' : (best.gameCode == 'OW' ? '옵치' : '배그')}]
									        </span>
									
									        <span style="font-weight: 500;">${best.boardTitle}</span>
									        
									        <c:if test="${best.replyCount > 0}">
									            <span style="color: var(--accent-blue); font-weight: 800; font-size: 12px;">[${best.replyCount}]</span>
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
				<h3>공지사항<button class="btn-mini" style="background:#fff">
                <a href="<c:url value = '/board/notice'/>">목록</a></button></h3>
				<c:choose>
            <c:when test="${empty noticeList}">
                <div class="list-item" style="color: #94a3b8;">공지사항이 없습니다.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="notice" items="${noticeList}">
                    <%-- 클릭 시 해당 공지사항 상세보기로 이동 --%>
                    <div class="list-item" style="cursor:pointer; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" 
                         title="${notice.boardTitle}"
                         onclick="location.href='<c:url value='/board/noticeView?boardNo=${notice.boardNo}'/>'">
                        <span style="color: #64748b; font-size: 13px; margin-right: 5px;">
                            <fmt:formatDate value="${notice.postDate}" pattern="MM.dd"/>
                        </span>
                        ${notice.boardTitle}
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
			</div>
		</aside>
	</div>

	<%@ include file="common/footer.jsp"%>
</body>
</html>