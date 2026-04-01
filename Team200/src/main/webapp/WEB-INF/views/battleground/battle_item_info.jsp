<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%-- 게임 식별자 및 헤더 정보 설정 --%>
<c:set var="gameId" value="battleground" />
<c:set var="currentGameName" value="배틀그라운드" />
<c:set var="headerTitle" value="배틀그라운드" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/battleground/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/battleground/script.js" defer></script>
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
    <%-- 검색 및 툴팁 스크립트가 있다면 추가 --%>
    <script src="${pageContext.request.contextPath}/resources/search/script.js" defer></script>
    
    <title>배틀그라운드 아이템 정보 - LOG.GG</title>
</head>
<body> 
    <%-- 공통 헤더 로드 --%>
    <%@ include file="../common/header.jsp"%>

    <div class="main-layout">
        <%-- 왼쪽 사이드바: 게시판 및 카테고리 링크 --%>
        <aside class="side-left">
            <%@ include file="../common/sidebar.jsp" %>
        </aside>

        <%-- 메인 콘텐츠 영역 --%>
        <main class="content-area">
            <div class="top-row">
                <a href="<c:url value='/bg/main'/>" style="text-decoration: none;">
                    <div class="logo">LOG.GG</div>
                </a>
                <%-- 롤 디자인: 검색바 추가 --%>
                <div class="search-bar">
                    <input type="text" id="itemSearchInput" class="search-input-field" placeholder="아이템 이름 검색"> 
                    <span style="cursor:pointer">🔍</span>
                </div>
            </div>

            <div class="item-card">
                <%-- 롤 디자인: 알약(Pill) 형태의 카테고리 메뉴 --%>
                <div class="item-categories">
                    <a href="<c:url value='/bg/item?category=0'/>" class="category-btn ${currentCategory == 0 ? 'active' : ''}" style="text-decoration: none;">
                        <div class="category-icon"></div>
                        <span>전체</span>
                    </a>
                    
                    <c:forEach var="cat" items="${categoryList}">
                        <a href="<c:url value='/bg/item?category=${cat.categoryNo}'/>" class="category-btn ${currentCategory == cat.categoryNo ? 'active' : ''}" style="text-decoration: none;">
                            <div class="category-icon"></div>
                            <span>${cat.categoryName}</span>
                        </a>
                    </c:forEach>
                </div>

                <%-- 아이템 데이터 테이블 --%>
                <div class="item-table-container">
                    <%-- 롤 디자인: 우측 상단 페이지 컨트롤러 --%>
                    <div class="table-controls" style="display: flex; justify-content: flex-end; align-items: center; gap: 10px; margin-bottom: 10px;">
                        <span style="font-size: 14px; font-weight: bold; color: #1e293b;">
                            <span id="currentPage">1</span> / <span id="totalPage">1</span>
                        </span>
                        <button id="prevBtn" class="page-nav-btn">◀</button>
                        <button id="nextBtn" class="page-nav-btn">▶</button>
                    </div>

                    <table class="item-table">
                        <thead>
                            <tr>
                                <th class="icon" style="width: 100px;">아이콘</th> <%-- 너비 약간 확장 --%>
                                <th class="name-price" style="width: 200px;">이름</th>
                                <th class="name-price" style="width: 120px;">종류</th>
                            </tr>
                        </thead>
                        <tbody id="itemTableBody">
                            <c:choose>
                                <c:when test="${empty itemList}">
                                    <tr>
                                        <td colspan="4" style="padding: 100px 0; color: #94a3b8; text-align: center;">등록된 아이템 정보가 없습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="item" items="${itemList}">
                                        <%-- JS 툴팁 연동을 위한 data 속성 추가 --%>
                                        <tr class="item-row" data-info="${item.itemInfo}" data-name="${item.itemName}">
                                            <td>
                                                <div class="item-img-placeholder" style="background: none; border: none;">
                                                    <%-- ✨ 이미지 크기를 64px로 확대 ✨ --%>
                                                    <img src="${item.itemImg}" alt="${item.itemName}" onerror="this.src='${pageContext.request.contextPath}/resources/img/default_item.png'" style="width: 64px; height: 64px; border-radius: 5px; object-fit: contain;">
                                                </div>
                                            </td>
                                            <td class="item-name-cell" style="font-weight: bold; color: #1e293b;">${item.itemName}</td>
                                            <td class="name-price" style="color: #3b82f6; font-weight: 700;">${item.itemType}</td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>

        <%-- 오른쪽 사이드바: 뉴스 및 공지 --%>
        <aside class="side-right">
            <div class="side-card" style="background: #cbd5e1; height: 300px; padding: 20px; border-radius: 12px;">
                <h3 style="margin-bottom: 15px; font-size: 16px; font-weight: 800; color: #1e293b;">아이템 소식</h3>
                <div style="font-size: 14px; color: #475569; line-height: 1.8;">
                    배틀그라운드 신규 패치 무기 데미지 조정안이 적용되었습니다.
                </div>
            </div>
        </aside>
    </div>

    <%-- 공통 푸터 로드 --%>
    <%@ include file="../common/footer.jsp"%>
    
    <%-- 롤 디자인: 툴팁을 띄우기 위한 숨김 div --%>
    <div id="item-tooltip" style="display:none; position:absolute; z-index:9999;"></div>
</body>
</html>