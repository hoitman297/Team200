<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
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
	<%@ include file="../common/header.jsp" %>
    
    
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
                    <input type="text" placeholder="영웅 검색">
                    <span>🔍</span>
                </div>
            </div>
            <div class="detail-card">
                <div class="hero-title">영웅 이름 / 역할군</div>

                <div class="hero-info-top">
                    <div class="hero-illust">일러스트</div>
                    <div class="hero-desc-text">
                        <div>챔피언 배경 이야기 및 소개</div>
                        <div>주요 포지션</div>
                        <div>난이도 / 공격 타입</div>
                    </div>
                </div>

                <div class="detail-tabs">   
                    <a href="#skill"><div class="d-tab active">스킬</div></a>
                    <a href="#skin"><div class="d-tab">스킨</div></a>
                    <a href="#sp"><div class="d-tab">특전</div></a>
                    <a href="#patch"><div class="d-tab">패치</div></a>
                </div>

                <div class="info-section" id = "skill">
                    <h4>스킬 목록</h4>
                    <div class="skill-list">
                        <div class="skill-item"><input type="checkbox"> L-CLICK - </div>
                        <div class="skill-item"><input type="checkbox"> SHIFT - </div>
                        <div class="skill-item"><input type="checkbox"> E - </div>
                        <div class="skill-item"><input type="checkbox"> R - </div>
                    </div>
                </div>

                <div class="info-section" id = "skin">
                    <h4>스킨 목록</h4>
                    <div class="skin-list">
                        <div class="skin-box"></div>
                        <div class="skin-box"></div>
                        <div class="skin-box"></div>
                    </div>
                </div>

                <div class="info-section" id = "sp">
                    <h4>특전 목록</h4>
                    <div style="font-size: 14px; color: #94a3b8;">내용이 없습니다.</div>
                </div>

                <div class="info-section" id = "patch">
                    <h4>패치 내역</h4>
                    <div style="font-size: 14px; color: #94a3b8;">최근 패치 내역이 없습니다.</div>
                </div>

                <div class="comment-row">
                    <div>댓글 글쓴이 |</div>
                    <div class="comment-main">댓글 내용</div>
                    <div class="comment-side">
                        <span>| 댓글신고 |</span>
                        <span>공감</span>
                    </div>
                </div>
            </div>
        </main>

        <aside class="side-right">
            <div class="side-card" style="background: #cbd5e1; height: 300px;">
                <h3>최근 업데이트</h3>
            <div style="font-size: 14px; color: #475569; line-height: 1.8;">
                최신 업데이트 내용을 확인하세요.
            </div>
            </div>
        </aside>
    </div>
    
	<%@ include file="../common/footer.jsp" %>

</body>
</html>