<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/admin/user_management/style.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/admin/user_management/script.js"></script>
    
    <title>LOG.GG - 관리자 회원 관리</title>
    <meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
</head>
<body>

    <div class="admin-header">
        <h2>전체 회원 목록 조회</h2>
        <button class="btn-back-home" onclick="history.back()">마이페이지로 돌아가기</button>
    </div>

    <div class="member-list-container">
        <div class="list-controls">
            <div class="search-box">
                <input type="text" placeholder="아이디, 이름, 이메일 검색">
                <button class="btn-action">검색</button>
            </div>
            <div class="filter-box">
                <select class="btn-action">
                    <option>가입일순</option>
                    <option>최근접속순</option>
                </select>
            </div>
        </div>

        <table class="member-table">
            <thead>
                <tr>
                    <th>번호</th>
                    <th>아이디</th>
                    <th>이름</th>
                    <th>이메일</th>
                    <th>상태</th>
                    <th>가입일</th>
                    <th>관리</th>
                </tr>
            </thead>
          <tbody>
           <c:forEach items="${userList}" var="member">
            
                <tr>
                    <td>${member.userNo}</td>
                    <td><strong>${member.userId}</strong></td>
                    <td>${member.userName}</td>
                    <td>${member.email}</td>
                    <td id="status-${member.userNo}">
						<c:choose>
		                    <c:when test="${member.withdraw eq 'N'}">
		                        <span class="status-badge status-active">활성</span>
		                    </c:when>
		                    <c:otherwise>
		                        <span class="status-badge status-inactive">정지</span>
		                    </c:otherwise>
		                </c:choose>
					</td>
                    <td><fmt:formatDate value="${member.enrollDate}" pattern="yy-MM-dd HH:mm" /></td>
                    <td>
                        <button id="btn-toggle-${member.userNo}" class="btn-action" 
                   			 onclick="toggleUserStatus(${member.userNo}, '${member.withdraw}')">
			               	 ${member.withdraw eq 'N' ? '정지' : '해제'}
			            </button>
			            <button class="btn-action btn-delete" onclick="deleteUser(${member.userNo})">삭제</button>
                    </td>
                </tr>
            </c:forEach>
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
    
     <script>
    /**
     * 1. 회원 상태(정지/활성) 토글 함수 (애니메이션 효과 포함)
     * @param {number} userNo - 회원 번호
     * @param {string} currentStatus - 현재 탈퇴 여부 ('N': 활성, 'Y': 정지)
     */
     function toggleUserStatus(userNo, currentStatus) {
    	    // currentStatus는 'N' 또는 'Y'
    	    const nextStatus = (currentStatus === 'N') ? 'Y' : 'N';
    	    const actionText = (nextStatus === 'Y') ? "정지" : "활성";

    	    console.log("현재상태: " + currentStatus + " -> 변경될상태: " + nextStatus);
    	    
    	    if (!confirm(`해당 회원을 \${actionText} 상태로 변경하시겠습니까?`)) return;
    	    
    	    const token = $("meta[name='_csrf']").attr("content");
    	    const header = $("meta[name='_csrf_header']").attr("content");

    	    $.ajax({
    	        url: "${pageContext.request.contextPath}/admin/updateUserWithdraw",
    	        type: "post",
    	        data: { 
    	        	userNo: userNo, 
    	        	withdraw: nextStatus // 'Y' or 'N'
    	        },
    	        beforeSend: function(xhr) {
    	            if(token && header) {
    	                xhr.setRequestHeader(header, token);
    	            }
    	        },
    	        success: function(result) {
    	            if (result > 0 || result === "success") {
    	                // 백틱(`) 대신 작은따옴표(')와 +를 사용해야 JSP와 충돌이 없습니다.
    	                var btn = $('#btn-toggle-' + userNo); 
    	                var statusBadge = $('#status-' + userNo);

    	                if (nextStatus === 'Y') {
    	                    statusBadge.html('<span class="status-badge status-suspended">정지</span>');
    	                    btn.text("해제");
    	                    // 다음 클릭 시 'Y'를 currentStatus로 던지도록 세팅
    	                    btn.attr("onclick", "toggleUserStatus(" + userNo + ", 'Y')"); 
    	                } else {
    	                    statusBadge.html('<span class="status-badge status-active">활성</span>');
    	                    btn.text("정지");
    	                    btn.attr("onclick", "toggleUserStatus(" + userNo + ", 'N')");
    	                }
    	                alert("상태가 변경되었습니다.");
    	            } else {
    	                alert("상태 변경에 실패했습니다.");
    	            }
    	        },
    	        error: function() {
    	        	alert("통신 실패"); 
    	        }
    	    });
    	}

    /**
     * 2. 회원 삭제 함수 (행 숨기기 애니메이션 포함)
     * @param {number} userNo - 회원 번호
     */
     function deleteUser(userNo) {
    	    if (!confirm("정말로 삭제하시겠습니까?")) return;
			
    	    const token = $("meta[name='_csrf']").attr("content");
    	    const header = $("meta[name='_csrf_header']").attr("content");
    	    
    	    $.ajax({
    	        url: "${pageContext.request.contextPath}/admin/deleteUser",
    	        type: "POST",
    	        data: {
    	        	userNo: userNo 
    	        },
    	        beforeSend: function(xhr) {
    	            if(token && header) {
    	                xhr.setRequestHeader(header, token);
    	            }
    	        },
    	        success: function(result) {
    	            if (result === "success") {
    	                alert("삭제되었습니다.");
    	                $(`#user-row-${userNo}`).remove(); // 즉시 행 삭제
    	            }
    	        },
    	        error: function() { alert("삭제 실패"); }
    	    });
    	}
    </script>
    
    <style>
    .alert-success {
	    position: fixed;
	    top: 50%;
	    left: 50%;
	    transform: translate(-50%, -50%);
	    background-color: rgba(30, 41, 59, 0.9);
	    color: white;
	    padding: 15px 30px;
	    border-radius: 8px;
	    z-index: 9999;
	    display: none;
	    box-shadow: 0 4px 12px rgba(0,0,0,0.2);
	}
    </style>
</body>
</html>