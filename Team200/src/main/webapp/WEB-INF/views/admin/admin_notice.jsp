<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/admin/admin_notice/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    <script src="${pageContext.request.contextPath}/resources/admin/admin_mypage/script.js"></script>
    
    <title>LOG.GG - 공지사항 등록 (1440x1024)</title>
    <%@ include file="../common/header.jsp"%>
</head>
<body>
    <div class="main-layout">
        <aside class="side-left">
            <div class="side-card">
                <div class="card-header">
                    <span>게임별 패치노트</span>
                </div>
                <div style="font-weight: 700; color: var(--primary-navy); font-size: 14px; margin-bottom: 10px;">최신 패치 현황</div>
        
		        <ul style="list-style: none; padding: 0; margin: 0; font-size: 13px; color: #475569; line-height: 2.0;">
		            <c:choose>
		                <c:when test="${empty recentPatchList}">
		                    <li>등록된 패치노트가 없습니다.</li>
		                </c:when>
		                <c:otherwise>
		                    <c:forEach var="p" items="${recentPatchList}">
		                        <%-- 제목이 길면 말줄임 처리 + 클릭 시 상세 보기 --%>
		                        <li style="overflow: hidden; text-overflow: ellipsis; white-space: nowrap; cursor: pointer; border-bottom: 1px solid #f1f5f9; padding-bottom: 5px; margin-bottom: 5px;"
		                            title="${p.boardTitle}"
		                            onclick="location.href='<c:url value='/board/patchnoteView?boardNo=${p.boardNo}'/>'">
		                            <strong>[${p.gameCode == 'LOL' ? '롤' : (p.gameCode == 'OW' ? '옵치' : '배그')}]</strong> 
		                            ${p.boardTitle}
		                        </li>
		                    </c:forEach>
		                </c:otherwise>
		            </c:choose>
		        </ul>
            </div>
        </aside>

        <main class="content-area">
            <div class="register-card">
                <div class="page-header">
                    <h2 class="page-title">공지사항 등록</h2>
                    <button class="btn-back" onclick="history.back()">← 목록으로 돌아가기</button>
                </div>

                <div class="input-group">
                    <label>분류 선택</label>
                    <select class="category-select">
                        <option>공지사항</option>
                        <option>점검안내</option>
                        <option>알림</option>
                    </select>
                </div>
         <form:form modelAttribute="notice" action="notice" method="POST">
                <div class="input-group">
                    <label>공지 제목</label>



                    <form:input path="title" type="text" class="title-input" placeholder="공지사항의 제목을 입력하세요." required="true"/>

                </div>

                <div class="input-group">
                    <label>본문 내용</label>
                    <div class="content-editor">



                        <form:textarea path="noticeContent" placeholder="사용자들에게 전달할 상세 내용을 작성하세요." required="true"/>

                    </div>
                </div>

                <div class="submit-area">
                    <button class="btn-submit">공지사항 등록</button>
                </div>
        </form:form>
            </div>
        </main>

        <aside class="sidebar-right">
		    <div class="notice-card">
		        <div class="card-header" style="margin-bottom: 10px;">
		            <span style="color: #1e293b; font-weight: bold;">최근 등록된 공지</span>
		        </div>
		        <ul class="notice-list" style="list-style: none; padding: 0; margin: 0; font-size: 13px; color: #475569; line-height: 2.0;">
		            <c:choose>
		                <c:when test="${empty recentNoticeList}">
		                    <li>등록된 공지가 없습니다.</li>
		                </c:when>
		                <c:otherwise>
		                    <c:forEach var="n" items="${recentNoticeList}">
		                        <li style="overflow: hidden; text-overflow: ellipsis; white-space: nowrap; cursor: pointer; border-bottom: 1px solid #f1f5f9; padding-bottom: 5px; margin-bottom: 5px;"
		                            title="${n.boardTitle}"
		                            onclick="location.href='<c:url value='/board/noticeView?boardNo=${n.boardNo}'/>'">
		                            • ${n.boardTitle}
		                            <span style="display: block; font-size: 11px; color: #94a3b8; margin-top: 2px; margin-left: 10px;">
		                                <fmt:formatDate value="${n.postDate}" pattern="yyyy.MM.dd"/>
		                            </span>
		                        </li>
		                    </c:forEach>
		                </c:otherwise>
		            </c:choose>
		        </ul>
		    </div>
		</aside>
    </div>
</body>
</html>