<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/member/comment_edit/style.css">
	<script src="${pageContext.request.contextPath}/resources/member/comment_edit/style.css"></script>
	
    <title>LOG.GG - 댓글 수정 및 삭제 관리</title>
</head>
<body>

<div class="manage-container">
    <div class="header">
        <h2>📝 나의 댓글 관리</h2>
        <div class="stats">작성한 댓글 총 <b>48개</b></div>
    </div>

    <div class="control-bar">
        <button class="btn btn-delete-selected" onclick="deleteSelected()">선택 삭제</button>
    </div>

    <table>
        <thead>
            <tr>
                <th class="col-check"><input type="checkbox" id="checkAll"></th>
                <th class="col-content">내용</th>
                <th class="col-date">날짜</th>
                <th class="col-action">관리</th>
            </tr>
        </thead>
        <tbody id="commentTableBody">
            <tr id="row-1">
                <td class="col-check"><input type="checkbox" class="chk"></td>
                <td class="col-content">
                    <span class="text-view">좋은 정보 감사합니다! 덕분에 티어 올렸어요.</span>
                    <input type="text" class="edit-input" value="좋은 정보 감사합니다! 덕분에 티어 올렸어요.">
                    <a href="#" class="original-post">원문: 오늘 자 랭크 게임 메타 정리.txt [5]</a>
                </td>
                <td class="col-date">2026.03.08</td>
                <td class="col-action">
                    <span class="action-link" onclick="toggleEdit(1)">수정</span>
                    <span class="action-link delete" onclick="deleteRow(1)">삭제</span>
                </td>
            </tr>
            <tr id="row-2">
                <td class="col-check"><input type="checkbox" class="chk"></td>
                <td class="col-content">
                    <span class="text-view">이 스킨 언제 출시되나요? 진짜 역대급인데.</span>
                    <input type="text" class="edit-input" value="이 스킨 언제 출시되나요? 진짜 역대급인데.">
                    <a href="#" class="original-post">원문: 신규 캐릭터 스킨 유출 정보 공유합니다. [12]</a>
                </td>
                <td class="col-date">2026.03.04</td>
                <td class="col-action">
                    <span class="action-link" onclick="toggleEdit(2)">수정</span>
                    <span class="action-link delete" onclick="deleteRow(2)">삭제</span>
                </td>
            </tr>
        </tbody>
    </table>

    <button class="btn btn-prev" onclick="history.back()">이전 페이지</button>
</div>
</body>
</html>