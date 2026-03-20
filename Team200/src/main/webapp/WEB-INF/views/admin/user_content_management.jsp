<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/admin/user_content_management/style.css">
    <script src="${pageContext.request.contextPath}/resources/admin/user_content_management/script.js"></script>
    
    <title>LOG.GG - 회원 콘텐츠 관리</title>
</head>
<body>

    <div class="container">
        <div class="header-section">
            <h2>회원 게시물 / 댓글 관리</h2>
            <div class="filter-group">
                <select class="select-box">
                    <option>🎮 전체 게임</option>
                    <option>배틀그라운드</option>
                    <option>오버워치</option>
                    <option>리그 오브 레전드</option>
                </select>
                <select class="select-box">
                    <option>최신순</option>
                    <option>신고많은순</option>
                </select>
            </div>
        </div>

        <div class="tab-menu">
            <div class="tab-item active" onclick="switchTab(this, 'post')">게시물 관리</div>
            <div class="tab-item" onclick="switchTab(this, 'comment')">댓글 관리</div>
        </div>

        <div class="content-card">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th width="80">번호</th>
                        <th width="120">게임</th>
                        <th>제목/내용</th>
                        <th width="120">작성자</th>
                        <th width="120">날짜</th>
                        <th width="100">관리</th>
                    </tr>
                </thead>
                <tbody id="admin-list-body">
                    <tr>
                        <td>124</td>
                        <td><span style="color:#3b82f6; font-weight:700;">배틀그라운드</span></td>
                        <td class="text-left">에란겔 짤파밍 꿀팁 공유합니다.</td>
                        <td><span class="author-tag">USER01</span></td>
                        <td>03.09</td>
                        <td><button class="btn-delete" onclick="deleteItem(this)">삭제</button></td>
                    </tr>
                    <tr>
                        <td>123</td>
                        <td><span style="color:#ef4444; font-weight:700;">오버워치</span></td>
                        <td class="text-left">이번 패치 딜러 버프 체감 되나요?</td>
                        <td><span class="author-tag">Kim_Log</span></td>
                        <td>03.08</td>
                        <td><button class="btn-delete" onclick="deleteItem(this)">삭제</button></td>
                    </tr>
                </tbody>
            </table>

            <div class="pagination">
                <span>&lt; 이전</span>
                <span class="active">1</span>
                <span>2</span>
                <span>3</span>
                <span>4</span>
                <span>5</span>
                <span>다음 &gt;</span>
            </div>
        </div>
    </div>
</body>
</html>