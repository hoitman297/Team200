<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="search-bar">
    <c:choose>

        <%-- 2. 게시판 검색창 --%>
        <c:when test="${searchType == 'board'}">
            <input type="text" id="boardSearchInput" class="search-input-field" placeholder="${boardTitle} 내 글 검색">
        </c:when>

        <%-- 3. 영웅/챔피언 검색창 --%>
        <c:when test="${searchType == 'hero'}">
            <input type="text" id="heroSearchInput" class="search-input-field" placeholder="영웅 검색">
        </c:when>
    </c:choose>
    <span style="cursor:pointer">🔍</span>
</div>