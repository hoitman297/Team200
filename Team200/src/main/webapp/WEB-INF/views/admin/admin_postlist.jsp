<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/admin/admin_postList/style.css">
    <script src="${pageContext.request.contextPath}/resources/admin/admin_postList/script.js"></script>
    
    <title>LOG.GG - 콘텐츠 관리</title>
</head>
<body>

    <div class="container">
        <div class="header">
            <h2>공지사항 / 패치노트 관리</h2>
            <button class="btn-write">새 글 작성하기</button>
        </div>

        <div class="tab-menu">
            <div class="tab-item active" onclick="switchTab(this, 'notice')">공지사항</div>
            <div class="tab-item" onclick="switchTab(this, 'patch')">패치노트</div>
        </div>

        <div class="content-card">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th width="80">번호</th>
                        <th>제목</th>
                        <th width="120">작성일</th>
                        <th width="100">조회수</th>
                        <th width="150">관리</th>
                    </tr>
                </thead>
                <tbody id="list-body">
                    <tr>
                        <td>002</td>
                        <td class="title-link">[공지] 서버 정기 점검 안내 (03/12)</td>
                        <td>25-03-10</td>
                        <td>1,245</td>
                        <td>
                            <button class="btn-action">수정</button>
                            <button class="btn-action btn-delete">삭제</button>
                        </td>
                    </tr>
                    <tr>
                        <td>001</td>
                        <td class="title-link">[공지] 커뮤니티 이용 규칙 개정 안내</td>
                        <td>25-02-28</td>
                        <td>3,502</td>
                        <td>
                            <button class="btn-action">수정</button>
                            <button class="btn-action btn-delete">삭제</button>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div class="pagination">
                <span>&lt; 이전</span>
                <span class="active">1</span>
                <span>2</span>
                <span>3</span>
                <span>다음 &gt;</span>
            </div>
        </div>
    </div>
</body>
</html>