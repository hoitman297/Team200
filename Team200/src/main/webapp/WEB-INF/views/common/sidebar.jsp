<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="side-card">
    <h3>카테고리</h3>
    <a href="<c:url value='/gallery/list?game=${gameId}' />">

	<a href="<c:url value='/gallery/list?game=${gameId}' />">
        <div class="menu-item">갤러리</div>
    </a>
    
    <div class="menu-item-group">
        <div class="menu-item">게시판</div>
        <div class="sub-menu-container">
            <a href="<c:url value='/board/free_${gameId}' />">
                <div class="sub-item">자유게시판</div>
            </a>
            <a href="<c:url value='/board/strategy_${gameId}' />">
                <div class="sub-item">공략게시판</div>
            </a>
        </div>
    </div>
    
    <a href="<c:url value='/board/inquiry' />"><div class="menu-item">고객지원</div></a>
</div>