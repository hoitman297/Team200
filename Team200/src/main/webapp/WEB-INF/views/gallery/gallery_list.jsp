<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/gallery/gallery_list/style.css">
	<script src="${pageContext.request.contextPath}/resources/gallery/gallery.list/script.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
	<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
	
    <title>LOG.GG - 갤러리</title>
</head>
<body>
    <c:set var="headerTitle" value="갤러리" />
	<%@ include file="../common/header.jsp" %>

    <div class="main-layout">
        <aside class="side-left">
            <div class="side-card">
                <h3>카테고리</h3>
                <div class="menu-item active">갤러리</div>
                
                <div class="menu-item-group">
                    <div class="menu-item">게시판</div>
                    <div class="sub-menu-container">
                        <div class="sub-item" onclick="location.href='board-free.html'">자유게시판</div>
                        <div class="sub-item" onclick="location.href='board-tip.html'">공략게시판</div>
                    </div>
                </div>
                
                <div class="menu-item" onclick="location.href='qna-list.html'">고객지원</div>
            </div>
        </aside>

        <main class="content-area">
            <div class="logo">LOG.GG</div>

            <div class="gallery-container">
                <div class="gallery-header">
                    <h2>갤러리</h2>
                    <a href="write.html" class="btn-write">글쓰기</a>
                </div>

                <div class="gallery-grid">
                    <div class="gallery-item">
                        <div class="thumbnail-box">
                            <span class="badge-hot">HOT</span>
                            <div class="thumbnail-content">IMAGE 01</div>
                        </div>
                        <div class="item-title">배틀그라운드 역대급 교전</div>
                        <div class="item-info">
                            <span>조회 1.2k</span>
                            <span class="info-heart">❤ 150</span>
                        </div>
                    </div>

                    <div class="gallery-item">
                        <div class="thumbnail-box">
                            <span class="badge-video">▶ 0:30</span>
                            <div class="thumbnail-content">VIDEO 01</div>
                        </div>
                        <div class="item-title">신규 패치 미리보기 영상</div>
                        <div class="item-info">
                            <span>조회 850</span>
                            <span class="info-heart">❤ 42</span>
                        </div>
                    </div>

                    <div class="gallery-item">
                        <div class="thumbnail-box">
                            <div class="thumbnail-content">IMAGE 02</div>
                        </div>
                        <div class="item-title">오늘 찍은 풍경샷 공유합니다</div>
                        <div class="item-info">
                            <span>조회 320</span>
                            <span class="info-heart">❤ 12</span>
                        </div>
                    </div>
                    
                    <div class="gallery-item"><div class="thumbnail-box"><div class="thumbnail-content">IMG</div></div><div class="item-title">게시글 4</div><div class="item-info"><span>조회 10</span> <span class="info-heart">❤ 0</span></div></div>
                    <div class="gallery-item"><div class="thumbnail-box"><div class="thumbnail-content">IMG</div></div><div class="item-title">게시글 5</div><div class="item-info"><span>조회 10</span> <span class="info-heart">❤ 0</span></div></div>
                    <div class="gallery-item"><div class="thumbnail-box"><div class="thumbnail-content">IMG</div></div><div class="item-title">게시글 6</div><div class="item-info"><span>조회 10</span> <span class="info-heart">❤ 0</span></div></div>
                </div>

                <div class="pagination">
                    <a href="#" class="page-link">&lt;</a>
                    <a href="#" class="page-link active">1</a>
                    <a href="#" class="page-link">2</a>
                    <a href="#" class="page-link">&gt;</a>
                </div>
            </div>
        </main>

        <aside class="side-right">
            <div class="side-card" style="background: #cbd5e1; min-height: 200px;">
                <h3 style="border-bottom: none;">갤러리 안내</h3>
                <p style="font-size: 14px; color: #475569; line-height: 1.7; font-weight: 500;">
                    멋진 스크린샷과 영상을 공유해주세요.<br><br>
                    추천을 많이 받은 게시물은 메인 화면에 노출될 수 있습니다.
                </p>
            </div>
        </aside>
    </div>

    <footer>© 2026 LOG.GG 배틀그라운드 서비스. 모든 권리 보유.</footer>

</body>
</html>