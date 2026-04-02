<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%-- 1. 전달받은 gameId를 소문자로 정리 --%>
<c:set var="rawId" value="${fn:toLowerCase(not empty gameId ? gameId : (not empty param.game ? param.game : (not empty param.gameCode ? param.gameCode : 'lol')))}" />

<%-- 2. 🚨 404 방지 핵심 로직: 짧은 코드를 풀네임으로 변환하여 BoardController 매핑과 일치시킴 --%>
<c:choose>
    <c:when test="${rawId == 'bg' || rawId == 'battleground'}">
        <c:set var="safeGameId" value="battleground" />
    </c:when>
    <c:when test="${rawId == 'ow' || rawId == 'overwatch'}">
        <c:set var="safeGameId" value="overwatch" />
    </c:when>
    <c:otherwise>
        <c:set var="safeGameId" value="lol" />
    </c:otherwise>
</c:choose>

<div class="side-card">
    <h3>카테고리</h3>
    
    <%-- 갤러리 링크 --%>
    <a href="<c:url value='/gallery/list?gameCode=${safeGameId}' />">
        <div class="menu-item">갤러리</div>
    </a>
    
    <div class="menu-item-group">
        <div class="menu-item">게시판</div>
        <div class="sub-menu-container">
            <%-- 자유게시판 (예: /board/free_battleground) --%>
            <a href="<c:url value='/board/free_${safeGameId}' />">
                <div class="sub-item">자유게시판</div>
            </a>
            <%-- 공략게시판 --%>
            <a href="<c:url value='/board/strategy_${safeGameId}' />">
                <div class="sub-item">공략게시판</div>
            </a>
        </div>
    </div>
    
    <%-- 고객지원 링크 --%>
    <a href="<c:url value='/board/inquiry?game=${safeGameId}' />">
        <div class="menu-item">고객지원</div>
    </a>
</div>