<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%-- 
  안전장치: 만약 페이지에서 gameId를 못 받아왔다면 
  URL 파라미터(?game=)에서 찾고, 그것도 없으면 'all'로 설정해요! 
--%>
<c:set var="safeGameId" value="${not empty gameId ? gameId : (not empty param.game ? param.game : 'all')}" />

<div class="side-card">
    <h3>카테고리</h3>
    
    <%-- 갤러리 링크 --%>
    <a href="<c:url value='/gallery/list?game=${safeGameId}' />">
        <div class="menu-item">갤러리</div>
    </a>
    
    <div class="menu-item-group">
        <div class="menu-item">게시판</div>
        <div class="sub-menu-container">
            <%-- 자유게시판 (언더바 방식: free_lol 등) --%>
            <a href="<c:url value='/board/free_${safeGameId}' />">
                <div class="sub-item">자유게시판</div>
            </a>
            <%-- 공략게시판 (언더바 방식) --%>
            <a href="<c:url value='/board/strategy_${safeGameId}' />">
                <div class="sub-item">공략게시판</div>
            </a>
        </div>
    </div>
    
    <%-- ✨ 수정된 부분: 고객지원 링크에도 게임 정보를 넘겨줍니다! --%>
    <a href="<c:url value='/board/inquiry?game=${safeGameId}' />">
        <div class="menu-item">고객지원</div>
    </a>
</div>