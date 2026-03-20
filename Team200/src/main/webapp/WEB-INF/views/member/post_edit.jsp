<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/member/post_edit/style.css">
	<script src="${pageContext.request.contextPath}/resources/member/post_edit/script.js"></script>
	
    <title>LOG.GG - 게시글 보기</title>
</head>
<body>

    <div class="container">
        <div class="post-header">
            <h1 class="post-title">오늘 자 랭크 게임 메타 정리.txt</h1>
        </div>

        <div class="post-content">
            글 내용이 여기에 들어갑니다. <br>
            LOG.GG 커뮤니티 가이드라인을 준수해주세요.
        </div>

        <div class="action-buttons">
            <button class="btn btn-edit" onclick="handleEdit()">수정</button>
            <button class="btn btn-delete" onclick="handleDelete()">삭제</button>
        </div>

        <div class="post-footer">
            <div class="recommend-count">추천수 : <span id="rec-count">12</span></div>
            <div class="report-link">신고</div>
        </div>

        <div class="comment-section">
            <div class="comment-item">
                <div class="author">글쓴이 |</div>
                <div class="content">좋은 정보 감사합니다!</div>
                <div class="actions">
                    <span>|답글</span> <span>|댓글신고</span> <span>|공감</span>
                </div>
            </div>
            <div class="comment-item reply">
                <div class="author">ㄴ 글쓴이 |</div>
                <div class="content">도움이 되셨다니 다행이네요.</div>
                <div class="actions">
                    <span>|답글</span> <span>|댓글신고</span> <span>|공감</span>
                </div>
            </div>
        </div>
    </div>
</body>
</html>