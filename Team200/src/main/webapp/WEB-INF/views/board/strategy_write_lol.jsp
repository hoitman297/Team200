<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- ✨ URL 경로용 변수 추가! (영어 소문자로 깔끔하게!) ✨ --%>
<c:set var="gameId" value="lol" />

<%-- 1. 이 게임 게시판에만 보여줄 정보 세팅 --%>
<c:set var="boardTitle" value="리그오브레전드 공략 게시판" />
<c:set var="gameName" value="리그 오브 레전드" />
<c:set var="gameThemeCss" value="board/board_write/style.css" /> <%-- 게임별 전용 CSS가 있다면 경로 변경 --%>
<c:set var="boardNotice" value="욕설 및 비방글은 금지됩니다.<br>게시판 성격에 맞는 글을 작성해 주세요.<br>도배 시 이용 제한이 있을 수 있습니다." />
<c:set var="tempBoardType" value="strategy" />

<%-- 2. 공통 뼈대 파일 불러오기 --%>
<%@ include file="../common/board_strategywrite.jsp" %>