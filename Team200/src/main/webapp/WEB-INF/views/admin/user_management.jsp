<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/admin/user_management/style.css?v=1.1">
    <script src="${pageContext.request.contextPath}/resources/admin/user_management/script.js"></script>
    
    <title>LOG.GG - 관리자 회원 관리</title>
    <meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
</head>
<body>

    <div class="admin-header">
	    <h2>전체 회원 목록 조회</h2>
	    <button type="button" class="btn-back-home" onclick="location.href='${pageContext.request.contextPath}/admin/main'">
	        관리자 페이지로
	    </button>
	</div>
    
<div class="member-list-container">
    <div class="list-controls">
	    <div class="search-box">
	        <input type="text" id="keyword" value="${keyword}" placeholder="아이디, 이름, 이메일 검색" 
	               onkeyup="if(window.event.keyCode==13){applyUserFilter()}">
	        <button class="btn-action" onclick="applyUserFilter()">검색</button>
	    </div>
	    
	    <div class="filter-box">
	        <select class="btn-action" id="withdrawFilter" onchange="applyUserFilter()">
	            <option value="ALL" ${withdraw eq 'ALL' ? 'selected' : ''}>전체 상태</option>
	            <option value="N" ${withdraw eq 'N' ? 'selected' : ''}>활성 회원</option>
	            <option value="Y" ${withdraw eq 'Y' ? 'selected' : ''}>정지 회원</option>
	        </select>
	
	        <select class="btn-action" id="orderFilter" onchange="applyUserFilter()">
	            <option value="date" ${order eq 'date' ? 'selected' : ''}>가입일순</option>
	            <option value="name" ${order eq 'name' ? 'selected' : ''}>이름순</option>
	        </select>
	    </div>
	</div>

		<div style="color: red; font-weight: bold;">
		    전체 회원 수: ${pi.listCount} 명 <br>
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
		                        <span class="status-badge status-suspended">정지</span>
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

<!-- 		<div style="background: #eee; padding: 10px;"> -->
<%-- 		    디버깅 - 시작페이지: [${pi.startPage}], 끝페이지: [${pi.endPage}], 총페이지: [${pi.maxPage}] --%>
<!-- 		</div> -->

        <div class="pagination" style="display: flex; justify-content: center; align-items: center; gap: 8px;">
		
		    <c:if test="${pi.startPage > 1}">
		        <a href="user_management?cpage=${pi.startPage - 1}&keyword=${keyword}&order=${order}&withdraw=${withdraw}" title="이전 5개 그룹으로">&lt;&lt;</a>
		    </c:if>
		
		    <c:if test="${pi.currentPage > 1}">
		        <a href="user_management?cpage=${pi.currentPage - 1}&keyword=${keyword}&order=${order}&withdraw=${withdraw}" title="이전 페이지">&lt;</a>
		    </c:if>
		
		    <span class="page-numbers" style="margin: 0 5px;">
		        &lt; 
		        <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}" varStatus="status">
		            <c:choose>
		                <c:when test="${p eq pi.currentPage}">
		                    <strong style="color: #000; font-weight: 800; margin: 0 2px;">${p}</strong>
		                </c:when>
		                <c:otherwise>
		                    <a href="user_management?cpage=${p}&keyword=${keyword}&order=${order}&withdraw=${withdraw}" style="text-decoration: none; color: #666; margin: 0 2px;">${p}</a>
		                </c:otherwise>
		            </c:choose>
		            <c:if test="${not status.last}">
		                <span style="color: #ccc;">,</span>
		            </c:if>
		        </c:forEach>
		        &gt;
		    </span>
		
		    <c:if test="${pi.currentPage < pi.maxPage}">
		        <a href="user_management?cpage=${pi.currentPage + 1}&keyword=${keyword}&order=${order}&withdraw=${withdraw}" title="다음 페이지">&gt;</a>
		    </c:if>
		
		    <c:if test="${pi.endPage < pi.maxPage}">
		        <a href="user_management?cpage=${pi.endPage + 1}&keyword=${keyword}&order=${order}&withdraw=${withdraw}" title="다음 5개 그룹으로">&gt;&gt;</a>
		    </c:if>
		
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
     
     
     function applyUserFilter() {
    	    const keyword = document.getElementById('keyword').value;
    	    const order = document.getElementById('orderFilter').value;
    	    const withdraw = document.getElementById('withdrawFilter').value; // 변수명 변경
    	    
    	    location.href = "user_management?cpage=1" 
    	                  + "&keyword=" + encodeURIComponent(keyword) 
    	                  + "&order=" + order 
    	                  + "&withdraw=" + withdraw; // 파라미터명 변경
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