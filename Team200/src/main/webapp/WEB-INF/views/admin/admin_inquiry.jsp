<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/admin/admin_inquiry/style.css">
    <script src="${pageContext.request.contextPath}/resources/admin/admin_inquiry/script.js"></script>
    
    <title>LOG.GG - 관리자 문의 관리</title>
    <meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
</head>
<body>

    <div class="container">
        <div class="header-section">
            <h2>고객지원 (Admin)</h2>
            <button class="select-box" onclick="location.href='${pageContext.request.contextPath}/admin/main'">관리자 페이지로</button>
        </div>

        <div class="filter-group">
		    <select class="select-box" id="gameFilter" onchange="applyFilter()">
		        <option value="ALL" ${gameCode eq 'ALL' ? 'selected' : ''}>전체 게임</option>
		        <option value="BG" ${gameCode eq 'BG' ? 'selected' : ''}>배틀그라운드</option>
		        <option value="OW" ${gameCode eq 'OW' ? 'selected' : ''}>오버워치</option>
		        <option value="LOL" ${gameCode eq 'LOL' ? 'selected' : ''}>리그 오브 레전드</option>
		    </select>
		    <select class="select-box" id="answerStatusFilter" onchange="applyFilter()">
		        <option value="ALL" ${answerStatus eq 'ALL' ? 'selected' : ''}>상태 전체</option>
		        <option value="W" ${answerStatus eq 'W' ? 'selected' : ''}>답변대기</option>
		        <option value="C" ${answerStatus eq 'C' ? 'selected' : ''}>답변완료</option>
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
                        <td><fmt:formatDate value="${inquiry.postDate}" pattern="yy-MM-dd hh:mm" /></td>
	                        <td id="status-container-${inquiry.boardNo}">
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
                    <tr id="inquiry-row-${inquiry.boardNo}" class="inquiry-row" style="display:none;">
                        <td colspan="6">
                            <div class="reply-section">
                                <div class="inquiry-content">
                                    <strong>[문의 내용]</strong><br>
                                    ${inquiry.boardContent}
                                </div>
                                <textarea id="answer-text-${inquiry.boardNo}" placeholder="사용자에게 전달할 답변 내용을 입력하세요.">${inquiry.answer}</textarea>
                                <div style="text-align: right; margin-top: 10px;">
			                        <button class="btn-submit" onclick="submitAnswer(${inquiry.boardNo})">답변 등록</button>
			                    </div>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            
            <div class="pagination" style="display: flex; justify-content: center; align-items: center; gap: 8px; margin-top: 30px;">
			
			    <c:if test="${pi.startPage > 1}">
			        <a href="admin_inquiry?cpage=${pi.startPage - 1}" title="이전 그룹" style="text-decoration: none; color: #444; font-weight: bold; padding: 0 5px;">&lt;&lt;</a>
			    </c:if>
			
			    <c:if test="${pi.currentPage > 1}">
			        <a href="admin_inquiry?cpage=${pi.currentPage - 1}" title="이전 페이지" style="text-decoration: none; color: #444; font-weight: bold; padding: 0 5px;">&lt;</a>
			    </c:if>
			
			    <span class="page-numbers" style="margin: 0 5px; color: #333; font-size: 16px;">
			        &lt; 
			        <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}" varStatus="status">
					    <c:choose>
					        <c:when test="${p eq pi.currentPage}">
					            <strong style="...">${p}</strong>
					        </c:when>
					        <c:otherwise>
					            <a href="inquiry?cpage=${p}&gameCode=${gameCode}&answerStatus=${answerStatus}" 
					               style="text-decoration: none; color: #666; margin: 0 2px;">${p}</a>
					        </c:otherwise>
					    </c:choose>
					</c:forEach>
			        &gt;
			    </span>
			
			    <c:if test="${pi.currentPage < pi.maxPage}">
			        <a href="admin_inquiry?cpage=${pi.currentPage + 1}" title="다음 페이지" style="text-decoration: none; color: #444; font-weight: bold; padding: 0 5px;">&gt;</a>
			    </c:if>
			
			    <c:if test="${pi.endPage < pi.maxPage}">
			        <a href="admin_inquiry?cpage=${pi.endPage + 1}" title="다음 그룹" style="text-decoration: none; color: #444; font-weight: bold; padding: 0 5px;">&gt;&gt;</a>
			    </c:if>
			
			</div>
            
        </div>
    </div>
</body>

<script>
//1. 답변창 토글 함수
function toggleReply(boardNo) {
    const row = document.getElementById('inquiry-row-' + boardNo);
    if (row.style.display === 'none' || row.style.display === '') {
        // 다른 열려있는 답변창을 닫고 싶다면 여기서 처리 가능
        row.style.display = 'table-row';
    } else {
        row.style.display = 'none';
    }
}

// 2. 답변 등록 AJAX 함수
function submitAnswer(boardNo) {
    const answerContent = document.getElementById('answer-text-' + boardNo).value;
    
    if (!answerContent.trim()) {
        alert("답변 내용을 입력해주세요.");
        return;
    }

    if (!confirm("이 답변을 등록하시겠습니까?")) return;

    // CSRF 토큰 (필요 시)
    const token = document.querySelector("meta[name='_csrf']")?.content;
    const header = document.querySelector("meta[name='_csrf_header']")?.content;

    $.ajax({
        url: "${pageContext.request.contextPath}/admin/insertAnswer", // 서버 컨트롤러 매핑 주소
        type: "POST",
        data: {
            boardNo: boardNo,
            answerContent: answerContent
        },
        beforeSend: function(xhr) {
            if(token && header) xhr.setRequestHeader(header, token);
        },
        success: function(result) {
            if (result === "success") {
                alert("답변이 성공적으로 등록되었습니다.");
                
                // UI 업데이트: 상태 배지 변경 및 입력창 닫기
                const statusContainer = document.getElementById('status-container-' + boardNo);
                if (statusContainer) {
                    statusContainer.innerHTML = '<span class="status-badge status-done">답변완료</span>';
                }
                toggleReply(boardNo); // 답변창 닫기
            } else {
                alert("답변 등록에 실패했습니다.");
            }
        },
        error: function() {
            alert("서버 통신 오류가 발생했습니다.");
        }
    });
}

function applyFilter() {
    const game = document.getElementById('gameFilter').value;
    const answerStatus = document.getElementById('answerStatusFilter').value;
    // 필터 변경 시 무조건 1페이지로 이동
    location.href = "inquiry?cpage=1&gameCode=" + game + "&answerStatus=" + answerStatus;
}
</script>
</html>