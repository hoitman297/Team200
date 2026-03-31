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
                <a href="<c:url value='/bg/main'/>"><div class="logo">LOG.GG</div></a>
            </div>

            <div class="item-card">
                <%-- 아이템 카테고리 필터 (동적 생성) --%>
                <div class="item-categories">
                    <a href="<c:url value='/bg/item?category=0'/>" class="category-btn">
                        <div class="category-icon ${currentCategory == 0 ? 'active-border' : ''}">
                            <span class="all-text">ALL</span>
                        </div>
                        <span class="${currentCategory == 0 ? 'active-text' : ''}">전체</span>
                    </a>
                    
                    <c:forEach var="cat" items="${categoryList}">
                        <a href="<c:url value='/bg/item?category=${cat.categoryNo}'/>" class="category-btn">
                            <div class="category-icon ${currentCategory == cat.categoryNo ? 'active-border' : ''}">
                                <%-- 카테고리별 아이콘 이미지가 있을 경우 사용 --%>
                                <c:if test="${not empty cat.categoryImg}">
                                    <img src="${pageContext.request.contextPath}/resources/battleground/img/${cat.categoryImg}" alt="${cat.categoryName}">
                                </c:if>
                            </div>
                            <span class="${currentCategory == cat.categoryNo ? 'active-text' : ''}">${cat.categoryName}</span>
                        </a>
                    </c:forEach>
                </div>

                <%-- 아이템 데이터 테이블 --%>
                <div class="item-table-container">
                    <table class="item-table">
                        <thead>
                            <tr>
                                <th>아이콘</th>
                                <th>이름</th>
                                <th>종류</th>
                                <th>상세 정보</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty itemList}">
                                    <tr>
                                        <td colspan="4" class="no-data">등록된 아이템 정보가 없습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="item" items="${itemList}">
                                        <tr>
                                            <td>
                                                <div class="item-img-box">
                                                    <img src="${item.itemImg}" alt="${item.itemName}" onerror="this.src='${pageContext.request.contextPath}/resources/img/default_item.png'">
                                                </div>
                                            </td>
                                            <td class="item-name">${item.itemName}</td>
                                            <td><span class="type-tag">${item.itemType}</span></td>
                                            <td class="item-info-text">${item.itemInfo}</td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>

                    <%-- 페이징 처리 영역 --%>
                    <div class="pagination">
                        <button class="page-btn">← 이전</button>
                        <button class="page-btn">다음 →</button>
                    </div>
                </div>
            </div>
        </main>

        <%-- 오른쪽 사이드바: 뉴스 및 공지 --%>
        <aside class="side-right">
            <div class="side-card info-box">
                <h3>아이템 소식</h3>
                <p>최신 패치에서 조정된 무기 데미지 수치를 확인하세요!</p>
            </div>
        </aside>
    </div>

    <%-- 공통 푸터 로드 --%>
    <%@ include file="../common/footer.jsp"%>
</body>
</html>