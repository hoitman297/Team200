<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 1. 배그 게시판에만 보여줄 정보 세팅 --%>
<c:set var="boardTitle" value="배틀그라운드 자유 게시판" />
<c:set var="gameName" value="배틀그라운드" />
<c:set var="gameThemeCss" value="battleground/board.css" /> <%-- 배그 전용 CSS --%>
<c:set var="writeUrl" value="/board/free_write_battleground" />
<c:set var="boardNotice" value="검색 기능을 통해 이전에 올라온 배틀그라운드 꿀팁들을 쉽게 찾아보실 수 있습니다." />

<%-- ✨ URL 경로용 변수 추가 ✨ --%>
<c:set var="gameId" value="battleground" />

<%-- 2. 공통 뼈대(다른 폴더에 있는 common_board.jsp) 불러오기 --%>
<%-- common 폴더에 있다면 아래 경로가 맞습니다 --%>
<%@ include file="../common/board_free.jsp" %>