<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/board_view/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/board/board_view/script.js"></script>
	<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
    
    <title>LOG.GG - 게시글 보기</title>
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
                        <div class="sub-item active" onclick="location.href='board-free.html'">자유게시판</div>
                        <div class="sub-item" onclick="location.href='board-tip.html'">공략게시판</div>
                    </div>
                </div>
                
                <div class="menu-item" onclick="location.href='qna-list.html'">고객지원</div>
            </div>
        </aside>

        <main class="content-area">
            <div class="logo">LOG.GG</div>

            <article class="view-container">
                <div class="post-header">
                    <div class="post-category">자유 게시판</div>
                    <h1 class="post-title">오늘 배그 점검 시간 아시는 분 계신가요?</h1>
                    <div class="post-info">
                        <span>글쓴이: <b>배그왕01</b></span>
                        <span>날짜: <b>2025-03-09</b></span>
                        <span>조회수: <b>1,240</b></span>
                    </div>
                </div>

                <div class="post-body">
                    안녕하세요. 오늘 친구들이랑 배그 한판 하려고 하는데<br>
                    혹시 오늘 정기 점검 시간이 몇 시부터 몇 시까지인지 아시는 분 계신가요?<br><br>
                    공홈 가봐도 공지가 잘 안 보여서 여쭤봅니다! 아시는 분 댓글 부탁드려요.
                </div>

                <div class="post-action">
                    <button class="btn-action like">👍 공감 150</button>
                    <button class="btn-action" onclick="location.href='board-free.html'">목록으로</button>
                    <button class="btn-action report">🚨 신고</button>
                </div>

                <section class="comment-section">
                    <div class="comment-count">댓글 2</div>
                    
                    <div class="comment-form">
                        <textarea placeholder="댓글을 남겨보세요."></textarea>
                        <button class="comment-submit">등록</button>
                    </div>

                    <div class="comment-list">
                        <div class="comment-item">
                            <div class="comment-author">배그초보</div>
                            <div class="comment-text">보통 수요일 오전 9시부터 오후 1시까지 하더라고요!</div>
                            <div class="comment-utils">
                                <span>답글</span> | <span>신고</span> | <span>공감</span>
                            </div>
                        </div>

                        <div class="comment-item reply">
                            <div class="comment-author">ㄴ 글쓴이</div>
                            <div class="comment-text">아하 그렇군요! 답변 감사합니다 :)</div>
                            <div class="comment-utils">
                                <span>신고</span> | <span>공감</span>
                            </div>
                        </div>
                    </div>
                </section>
            </article>
        </main>

        <aside class="side-right">
            <div class="side-card">
                <h3>배틀그라운드 소식</h3>
                <p>
                    최신 패치노트와 공략을 확인하고<br>
                    승률을 높여보세요!<br>
                    현재 시즌 28 진행 중입니다.
                </p>
                <button class="btn-more">자세히 보기</button>
            </div>
        </aside>
    </div>

    <footer>© 2026 LOG.GG 배틀그라운드 서비스. 모든 권리 보유.</footer>

</body>
</html>