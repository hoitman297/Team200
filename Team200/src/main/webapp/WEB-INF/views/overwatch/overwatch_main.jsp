<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/overwatch/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/overwatch/script.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
<title>오버워치</title>
</head>

<body>
	<c:set var="headerTitle" value="오버워치" />
	<%@ include file="../common/header.jsp"%>

	<div class="main-layout">
		<aside class="side-left">
            <div class="side-card">
                <h3>카테고리</h3>
                <a href="<c:url value = '/gallery/list' />"><div class="menu-item">갤러리</div></a>
                
                <div class="menu-item-group">
                    <div class="menu-item">게시판</div>
                    <div class="sub-menu-container">
                        <a href="<c:url value = '/board/free_overwatch' />"><div class="sub-item">자유게시판</div></a>
                        <a href="<c:url value = '/board/strategy_overwatch' />"><div class="sub-item">공략게시판</div></a>
                    </div>
                </div>
                
                <a href="<c:url value = '/board/inquiry' />"><div class="menu-item">고객지원</div></a>
            </div>
        </aside>

		<main class="content-area">
			<div class="top-row">
				<a href="<c:url value ='/overwatch/main'/>"><div class="logo">LOG.GG</div></a>
				<div class="search-bar">
					<input type="text" placeholder="글 검색"> <span>🔍</span>
				</div>
			</div>

			<div class="board-card">
				<div class="tab-menu">
					<div class="tab-item">실시간 인기글</div>
					<a href="<c:url value = '/overwatch/hero_main' />">
						<div class="tab-item">영웅 정보</div>
					</a> <a href="<c:url value = '/overwatch/box' />">
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
					<div class="board-row">
						<div class="col-likes">150</div>
						<div class="col-title">오버워치 인게임 최근 소식 및 패치노트 안내</div>
						<div class="col-author">관리자</div>
						<div class="col-date">03.01</div>
					</div>
				</div>
			</div>

			<div class="bottom-grid">
				<div class="grid-box">
					<h4>갤러리</h4>
					<div class="thumb-container">
						<div class="thumb"></div>
						<div class="thumb"></div>
					</div>
				</div>
				<div class="grid-box">
					<h4>인게임 소식</h4>
					<div class="thumb-container">
						<div class="thumb"></div>
						<div class="thumb"></div>
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