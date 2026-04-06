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
    <script src="${pageContext.request.contextPath}/resources/search/script.js" defer></script>
    
    <title>배틀그라운드 아이템 정보 - LOG.GG</title>
</head>
<body> 
    <%@ include file="../common/header.jsp"%>

    <div class="main-layout">
        <aside class="side-left">
            <%@ include file="../common/sidebar.jsp" %>
        </aside>

        <main class="content-area">
            <div class="top-row">
                <a href="<c:url value='/bg/main'/>" style="text-decoration: none;">
                    <div class="logo">LOG.GG</div>
                </a>
                <div class="search-bar">
                    <input type="text" id="itemSearchInput" class="search-input-field" placeholder="아이템 이름 검색"> 
                    <span style="cursor:pointer">🔍</span>
                </div>
            </div>

            <div class="item-card">
                <div class="item-categories">
                    <%-- ✨ JS 처리를 위해 data-category 속성 추가 및 스타일 수정 ✨ --%>
                    <c:forEach var="cat" items="${categoryList}">
                        <div class="category-btn" data-category="${cat.categoryNo}" style="text-decoration: none; cursor: pointer;">
                            <div class="category-icon"></div>
                            <span>${cat.categoryName}</span>
                        </div>
                    </c:forEach>
                </div>

                <div class="item-table-container">
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
                                <th class="icon" style="width: 100px;">아이콘</th>
                                <th class="name-price" style="width: 200px;">이름</th>
                                <th class="name-price" style="width: 120px;">종류</th>
                            </tr>
                        </thead>
                        <tbody id="itemTableBody">
                            <c:choose>
                                <c:when test="${empty itemList}">
                                    <tr>
                                        <td colspan="3" style="padding: 100px 0; color: #94a3b8; text-align: center;">등록된 아이템 정보가 없습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="item" items="${itemList}">
                                        <%-- ✨ data-category 속성 추가 완료 ✨ --%>
                                        <tr class="item-row" data-category="${item.categoryNo}" data-info="${item.itemInfo}" data-name="${item.itemName}" data-type="${item.itemType}">
                                            <td>
                                                <div class="item-img-placeholder" style="background: none; border: none;">
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

        <aside class="side-right">
            <div class="side-card" style="background: #cbd5e1; height: 300px; padding: 20px; border-radius: 12px;">
                <h3 style="margin-bottom: 15px; font-size: 16px; font-weight: 800; color: #1e293b;">아이템 소식</h3>
                <div style="font-size: 14px; color: #475569; line-height: 1.8;">
                    배틀그라운드 신규 패치 무기 데미지 조정안이 적용되었습니다.
                </div>
            </div>
        </aside>
    </div>

    <%@ include file="../common/footer.jsp"%>
    <div id="item-tooltip" style="display:none; position:absolute; z-index:9999;"></div>
</body>
</html>