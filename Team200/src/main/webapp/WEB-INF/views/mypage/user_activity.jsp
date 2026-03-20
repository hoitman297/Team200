<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/mypage/user_activity/style.css">
	<script src="${pageContext.request.contextPath}/resources/mypage/user_activity/script.js"></script>
	
    <title>LOG.GG - 나의 활동 내역</title>
</head>
<body>

    <div class="activity-container">
        <div class="header">
            <h1>📝 나의 활동 내역</h1>
            <div class="stats">작성한 게시글 총 <b>12</b>개 | 댓글 <b>48</b>개</div>
        </div>

        <div class="tab-menu">
            <div class="tab-item active">작성한 게시글</div>
            <div class="tab-item">작성한 댓글</div>
        </div>

        <div class="game-filter">
            <button class="filter-btn active">전체</button>
            <button class="filter-btn">리그 오브 레전드</button>
            <button class="filter-btn">배틀그라운드</button>
            <button class="filter-btn">오버워치</button>
        </div>

        <table class="activity-table">
            <thead>
                <tr>
                    <th style="width: 60%;">제목</th>
                    <th style="width: 20%;">날짜</th>
                    <th style="width: 10%;">조회</th>
                    <th style="width: 10%;">공감</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <span class="game-tag tag-lol">LoL</span>
                        <a href="#" class="post-title">오늘 자 랭크 게임 메타 정리.txt</a>
                        <span class="comment-count">[5]</span>
                    </td>
                    <td class="meta-info">2026.03.06</td>
                    <td class="meta-info">1,240</td>
                    <td class="meta-info" style="color: #475569;">+12</td>
                </tr>
                <tr>
                    <td>
                        <span class="game-tag tag-ow">OW2</span>
                        <a href="#" class="post-title">신규 캐릭터 스킨 유출 정보 공유합니다.</a>
                        <span class="comment-count">[12]</span>
                    </td>
                    <td class="meta-info">2026.03.04</td>
                    <td class="meta-info">850</td>
                    <td class="meta-info" style="color: #475569;">+24</td>
                </tr>
                <tr>
                    <td>
                        <span class="game-tag tag-pubg">PUBG</span>
                        <a href="#" class="post-title">에란겔 짤파밍 효율 동선 공유</a>
                        <span class="comment-count">[8]</span>
                    </td>
                    <td class="meta-info">2026.03.02</td>
                    <td class="meta-info">2,100</td>
                    <td class="meta-info" style="color: #475569;">+45</td>
                </tr>
            </tbody>
        </table>

        <a href="#" class="btn-back" onclick="history.back(); return false;"> 이전 페이지</a>
    </div>

</body>
</html>