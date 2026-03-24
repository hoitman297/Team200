<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/board_write/style.css">
	<script src="${pageContext.request.contextPath}/resources/board/board_write/script.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
	<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>

    <title>LOG.GG - 공략게시판 글쓰기</title>
</head>
<body>
	<c:set var="headerTitle" value="게시판" />
    <%@ include file="../common/header.jsp" %>
    
    <div class="main-layout">
        <aside class="side-left">
            <div class="side-card">
                <h3>카테고리</h3>
                <div class="menu-item" onclick="location.href='gallery.html'">갤러리</div>
                
                <div class="menu-item-group">
                    <div class="menu-item">게시판</div>
                    <div class="sub-menu-container">
                        <a href="<c:url value = '/board/free' />"><div class="sub-item">자유게시판</div></a>
                        <a href="<c:url value = '/board/strategy' />"><div class="sub-item">공략게시판</div></a>
                    </div>
                </div>
                
                <a href="<c:url value = '/board/inquiry' />"><div class="menu-item">고객지원</div></a>
            </div>
        </aside>

        <main class="content-area">
            <a href="<c:url value = '/' />"><div class="logo">LOG.GG</div></a>

            <div class="write-container">
                <div class="category-fixed-bar">
                    <span class="category-tag">작성 중</span>
                    <span class="category-text" id="targetGame">배틀그라운드 > 공략 게시판</span>
                </div>

                <div class="write-header">
                    <h2>새 글 작성하기</h2>
                </div>

                <form id="writeForm">
                    <div class="form-group">
                        <label>제목</label>
                        <input type="text" placeholder="제목을 입력해 주세요" required>
                    </div>

                    <div class="form-group">
                        <label>내용</label>
                        <textarea class="editor-area" placeholder="커뮤니티 가이드라인을 준수하여 내용을 작성해 주세요."></textarea>
                        <div class="file-upload">📎 사진이나 파일을 드래그하여 첨부할 수 있습니다.</div>
                    </div>

                    <div class="write-footer">
                        <button type="button" class="btn btn-cancel" onclick="history.back()">취소</button>
                        <button type="submit" class="btn btn-submit">등록하기</button>
                    </div>
                </form>
            </div>
        </main>

        <aside class="side-right">
            <div class="side-card" style="background: #cbd5e1; min-height: 200px;">
                <h3>게시판 이용 수칙</h3>
                <p style="font-size: 14px; color: #475569; line-height: 1.7; font-weight: 500;">
                    • 욕설 및 비방글은 금지됩니다.<br>
                    • 게시판 성격에 맞는 글을 작성해 주세요.<br>
                    • 도배 시 이용 제한이 있을 수 있습니다.<br><br>
                    깨끗한 커뮤니티를 함께 만들어가요!
                </p>
            </div>
        </aside>
    </div>

    <footer>© 2026 LOG.GG 배틀그라운드 서비스. 모든 권리 보유.</footer>

</body>
</html>