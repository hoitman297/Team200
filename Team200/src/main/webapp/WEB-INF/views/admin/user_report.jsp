<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/admin/user_report/style.css">
    <script src="${pageContext.request.contextPath}/resources/admin/user_report/script.js"></script>
    
    <title>LOG.GG - 회원 콘텐츠 관리</title>
    <meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
</head>
<body>

    <div class="container">
        <div class="header-section">
		    <h2>신고내역</h2>
		   
		    <div class="filter-group">
		        
		        <select class="select-box" id="orderFilter" onchange="applyFilter()">
		            <option value="recent" ${order eq 'recent' ? 'selected' : ''}>최신순</option>
		            <option value="count" ${order eq 'count' ? 'selected' : ''}>신고많은순</option>
		        </select>
		          <button class="select-box" onclick="location.href='${pageContext.request.contextPath}/admin/main'">관리자 페이지로</button>
		    </div>
		</div>

        <div class="tab-menu">
            <div class="tab-item ${type eq 'post' ? 'active' : ''}" onclick="switchTab('post')">게시물 관리</div>
            <div class="tab-item ${type eq 'comment' ? 'active' : ''}" onclick="switchTab('comment')">댓글 관리</div>
        </div>
        
        <div class="content-card">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th width="80">신고번호</th>
                        <th width="120">유저번호</th>
                        <th>제목/내용</th>
                        <th>신고수</th>
                        <th>삭제</th>
                        <th width="120">처리날짜</th>
                    </tr>
                </thead>
                <tbody id="admin-list-body">
				    <c:choose>
				        <c:when test="${empty reportList}">
				            <tr><td colspan="6" style="text-align:center; padding:50px;">신고 내역이 없습니다.</td></tr>
				        </c:when>
				        
				        <c:otherwise>
				            <c:forEach items="${reportList}" var="r">
				                <tr>
				                    <td>${r.reportNo}</td>
				                    <td><span style="color:#3b82f6; font-weight:700;">
				                    	${r.userNo}</span>
				                    </td>
				                    <td class="text-left">
				                        <div style="display: flex; flex-direction: column; gap: 4px;">
				                            <%-- 상세 페이지 링크: type에 따라 경로와 번호를 다르게 바인딩 --%>
				                            <a href="${pageContext.request.contextPath}/board/view?boardNo=${r.boardNo}" 
									           style="text-decoration:none; color:#333; font-weight:600;" target="_blank">
									            ${r.title}
									        </a>
				                            <%-- 신고 사유 요약 (선택 사항) --%>
				                            <small style="color:#888; font-size:12px;">사유: ${r.reportType}</small>
				                        </div>
				                    </td>
				                    <td>
				                    ${r.reportCount }
				                    </td>
				                    <td>
				                        <button class="btn-delete" onclick="deleteItem('${type}', ${type eq 'post' ? r.boardNo : r.replyNo})">삭제</button>
				                    </td>
				                    	
				                    <td id="status-container-${r.reportNo}">
				                        <c:choose>
				                            <c:when test="${empty r.doneDate}">
				                                <span class="status-badge status-waiting">처리대기</span>
				                            </c:when>
				                            <c:otherwise>
				                                <span class="status-badge status-done"><fmt:formatDate value="${r.doneDate}" pattern="yy.MM.dd hh:mm" /></span>
				                            </c:otherwise>
				                        </c:choose>
				                    </td>
				                </tr>
				                <tr id="report-row-${r.reportNo}" class="inquiry-row" style="display:none; background:#fcfcfc;">
						            <td colspan="6">
						                <div class="reply-section" style="padding: 15px 30px; text-align: left; border-left: 5px solid #ff4d4f;">
						                    <div style="margin-bottom: 10px;">
						                        <strong style="color:#ff4d4f;">[신고 사유 상세]</strong>
						                        <p style="margin-top:8px; line-height:1.5;">${r.reportContent}</p>
						                    </div>
						                    <div style="text-align: right;">
						                        <button class="btn-delete" 
						                                style="background:#ff4d4f; color:#fff; border:none; padding:8px 20px; border-radius:4px; cursor:pointer;"
						                                onclick="deleteItem('${type}', ${type eq 'post' ? r.boardNo : r.replyNo})">
						                            해당 콘텐츠 삭제하기
						                        </button>
						                    </div>
						                </div>
						            </td>
						        </tr>
				            </c:forEach>
				        </c:otherwise>
				    </c:choose>
				</tbody>
            </table>

			            <div class="pagination" style="display: flex; justify-content: center; align-items: center; gap: 8px; margin-top: 30px;">
			    
			    <c:if test="${pi.startPage > 1}">
			        <a href="user_report?currentPage=${pi.startPage - 1}&type=${type}&order=${order}" title="이전 그룹" style="text-decoration: none; color: #444; font-weight: bold; padding: 0 5px;">&lt;&lt;</a>
			    </c:if>
			
			    <c:if test="${pi.currentPage > 1}">
			        <a href="user_report?currentPage=${pi.currentPage - 1}&type=${type}&order=${order}" title="이전 페이지" style="text-decoration: none; color: #444; font-weight: bold; padding: 0 5px;">&lt;</a>
			    </c:if>
			
			    <span class="page-numbers" style="margin: 0 5px; color: #333; font-size: 16px;">
			        <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
			            <c:choose>
			                <c:when test="${p eq pi.currentPage}">
			                    <strong style="color: #3b82f6;">${p}</strong>
			                </c:when>
			                <c:otherwise>
			                    <%-- ✨ 수정됨: 이동할 때마다 현재 탭(type)과 정렬(order)을 데리고 다닙니다! --%>
			                    <a href="user_report?currentPage=${p}&type=${type}&order=${order}" 
			                       style="text-decoration: none; color: #666; margin: 0 2px;">${p}</a>
			                </c:otherwise>
			            </c:choose>
			        </c:forEach>
			    </span>
			
			    <c:if test="${pi.currentPage < pi.maxPage}">
			        <a href="user_report?currentPage=${pi.currentPage + 1}&type=${type}&order=${order}" title="다음 페이지" style="text-decoration: none; color: #444; font-weight: bold; padding: 0 5px;">&gt;</a>
			    </c:if>
			
			    <c:if test="${pi.endPage < pi.maxPage}">
			        <a href="user_report?currentPage=${pi.endPage + 1}&type=${type}&order=${order}" title="다음 그룹" style="text-decoration: none; color: #444; font-weight: bold; padding: 0 5px;">&gt;&gt;</a>
			    </c:if>
			</div>
			
        </div>
    </div>
</body>



<script>
		const contextPath = "${pageContext.request.contextPath}";
		const currentType = "${empty type ? 'post' : type}"; // 현재 탭 상태 유지
		
		function switchTab(type) {
		    const orderEl = document.getElementById('orderFilter');
		    
		    const order = orderEl ? orderEl.value : 'recent';
		    
	        const targetUrl = contextPath + "/admin/user_report?type=" + type + 
	                          "&order=" + order + "&currentPage=1";
	        
	        console.log("이동 시도:", targetUrl);
	        location.href = targetUrl;
		}
		
		function applyFilter() {
		    // 현재 보고 있는 탭(currentType) 정보를 그대로 들고 새로고침.
		    switchTab(currentType || 'post');
		}
		
		function deleteItem(type, no) {
		    const typeNm = (type === 'post' ? "게시글" : "댓글");
		    
		    if(confirm(`해당 \${typeNm}을(를) 삭제하시겠습니까?\n삭제 시 관련 신고 내역도 모두 처리됩니다.`)) {
		        location.href = contextPath + "/admin/deleteContent?type=" + type + "&no=" + no;
		    }
		}
		
		function toggleReport(reportNo) {
		    const row = document.getElementById('report-row-' + reportNo);
		    if (row.style.display === 'none' || row.style.display === '') {
		        row.style.display = 'table-row';
		    } else {
		        row.style.display = 'none';
		    }
		}

		
</script>
</html>