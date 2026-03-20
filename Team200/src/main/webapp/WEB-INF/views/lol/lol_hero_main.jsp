<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/lol/style.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/lol/script.js" defer></script>
	<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
    <title>롤</title>
</head>
<body>
	<c:set var="headerTitle" value="롤" />
    <%@ include file="../common/header.jsp" %>
    
    
	    <div class="main-layout">
        <aside class="side-left">
            <div class="side-card">
                <h3>카테고리</h3>
                <div class="menu-item">갤러리</div>
                <div class="menu-item">게시판</div>
                <div class="sub-item">자유게시판</div>
                <div class="sub-item">공략게시판</div>
                <div class="menu-item">미디어</div>
                <div class="menu-item">1:1 문의</div>
            </div>
        </aside>

        <main class="content-area">
            <div class="top-row">
				<a href="<c:url value ='/lol/main'/>"><div class="logo">LOG.GG</div></a>
				<div class="search-bar">
                    <input type="text" placeholder="챔피언 검색">
                    <span>🔍</span>
                </div>
            </div>
            <div class="board-card">
                <div class="champ-grid-container">
                    <%-- Controller에서 넘어온 champList를 반복문으로 처리 --%>
                    <c:forEach var="champ" items="${champList}">
                        <div class="champ-item">
                            <div class="champ-img-box">
                                <%-- 
                                    이미지 파일명은 VO의 영문명(engName)을 쓰거나, 
                                    규칙이 없다면 ${champ.name}을 그대로 사용 
                                --%>
                                <img src="${pageContext.request.contextPath}/resources/images/champs/${champ.engName}.png" 
                                     alt="${champ.name}">
                            </div>
                            <div class="champ-name">
                                <c:out value="${champ.name}" />
                            </div>
                        </div>
                    </c:forEach>
                    
                    <%-- 만약 데이터가 없을 때 표시할 문구 --%>
                    <c:if test="${empty champList}">
                        <p style="text-align:center; width:100%; padding:20px;">등록된 챔피언이 없습니다.</p>
                    </c:if>
                </div>
            </div>
        </main>

        <aside class="side-right">
            <div class="side-card" style="background: #cbd5e1; height: 300px;">
                <h3>최근 업데이트</h3>
            <div style="font-size: 14px; color: #475569; line-height: 1.8;">
                최신 업데이트 내용을 확인하세요.
            </div>
            </div>
        </aside>
    </div>
    
	<%@ include file="../common/footer.jsp" %>

</body>
</html>