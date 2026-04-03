<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<c:choose>
    <%-- ✨ 전체 패치노트 조건 추가! --%>
    <c:when test="${gameId == 'all'}">
        <c:set var="boardTitle" value="전체 게임 패치노트" />
        <c:set var="gameThemeCss" value="main/style.css" /> <%-- 메인 공통 CSS 사용 --%>
        <c:set var="boardNotice" value="LOG.GG가 제공하는 모든 게임의 최신 업데이트 내역을 한눈에 확인하세요!" />
    </c:when>

    <%-- 기존 로직들 (lol, ow, bg) --%>
    <c:when test="${gameId == 'lol'}">
        <c:set var="boardTitle" value="리그 오브 레전드 패치노트" />
        <c:set var="gameThemeCss" value="lol/board.css" />
        <c:set var="boardNotice" value="리그 오브 레전드의 최신 업데이트 내역을 확인하세요!" />
    </c:when>
    <c:when test="${gameId == 'overwatch' or gameId == 'ow' or gameId == 'OW'}">
        <c:set var="boardTitle" value="오버워치 패치노트" />
        <c:set var="gameThemeCss" value="overwatch/style.css" /> 
        <c:set var="boardNotice" value="오버워치의 최신 영웅 밸런스 패치를 확인하세요!" />
    </c:when>
    <c:otherwise>
        <c:set var="boardTitle" value="배틀그라운드 패치노트" />
        <c:set var="gameThemeCss" value="battleground/style.css" /> 
        <c:set var="boardNotice" value="배틀그라운드의 최신 총기 밸런스 및 맵 업데이트를 확인하세요!" />
    </c:otherwise>
</c:choose>

<%-- 공통 변수 세팅 --%>
<c:set var="gameName" value="패치노트" /> 
<c:set var="writeUrl" value="/admin/patchnoteWrite?gameCode=${gameId}" /> 
<c:set var="isPatchnote" value="true" />

<%-- 껍데기(자유게시판) 불러오기 --%>
<%@ include file="../common/board_free.jsp" %>