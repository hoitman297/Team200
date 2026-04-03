<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- ✨ 공지사항 전용 설정 --%>
<c:set var="boardTitle" value="서비스 공지사항" />
<c:set var="gameThemeCss" value="main/style.css" /> <%-- 공통 메인 CSS 사용 --%>
<c:set var="boardNotice" value="LOG.GG의 새로운 소식과 점검 안내를 확인하세요!" />

<%-- 공통 변수 세팅 --%>
<c:set var="gameName" value="공지사항" /> 
<c:set var="writeUrl" value="/admin/noticeWrite" /> <%-- 관리자 공지 작성 경로 --%>

<%-- 📌 중요: 패치노트가 아니라는 것을 명시하고, 공지사항임을 알림 --%>
<c:set var="isPatchnote" value="" />
<c:set var="isNotice" value="true" />

<%-- 껍데기(자유게시판 리스트 틀) 불러오기 --%>
<%@ include file="../common/board_free.jsp" %>