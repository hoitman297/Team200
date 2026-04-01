<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/admin/admin_inquiry/style.css">
    <script src="${pageContext.request.contextPath}/resources/admin/admin_inquiry/script.js"></script>
    
    <title>LOG.GG - 관리자 문의 관리</title>
</head>
<body>

    <div class="container">
        <div class="header-section">
            <h2>고객지원 (Admin)</h2>
            <button class="select-box" onclick="history.back()">뒤로가기</button>
        </div>

        <div class="filter-group">
            <select class="select-box">
                <option>전체 게임</option>
                <option>배틀그라운드</option>
                <option>오버워치</option>
                <option>리그 오브 레전드</option>
            </select>
            <select class="select-box">
                <option>상태 전체</option>
                <option>답변대기</option>
                <option>답변완료</option>
            </select>
        </div>

        <div class="content-card">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th width="80">번호</th>
                        <th width="120">분류</th>
                        <th>제목</th>
                        <th width="120">작성자</th>
                        <th width="120">날짜</th>
                        <th width="120">상태</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach items="${inquiryList}" var="inquiry">
                    <tr class="clickable-row" onclick="toggleReply(${inquiry.boardNo})">
                        <td>${inquiry.boardNo}</td>
                        <td>${inquiry.gameCode}</td>
                        <td style="text-align:left;">${inquiry.boardTitle}</td>
                        <td>${inquiry.userName}</td>
                        <td><fmt:formatDate value="${inquiry.postDate}" pattern="yy-MM-dd" /></td>
                        <td>
                        	<c:choose>
			                    <c:when test="${inquiry.answerStatus eq 'C'}">
			                        <span class="status-badge status-done">답변완료</span>
			                    </c:when>
			                    <c:otherwise>
			                        <span class="status-badge status-waiting">답변대기</span>
			                    </c:otherwise>
			                </c:choose>
						</td>
                    </tr>
                    <tr id="reply-3" style="display:none;">
                        <td colspan="6">
                            <div class="reply-section">
                                <div class="inquiry-content">
                                    <strong>[문의 내용]</strong><br>
                                    ${inquiry.boardContent}
                                </div>
                                <textarea placeholder="사용자에게 전달할 답변 내용을 입력하세요."></textarea>
                                <button class="btn-submit" onclick="alert('답변이 등록되었습니다.')">답변 등록</button>
                            </div>
                        </td>
                    </tr>

                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>