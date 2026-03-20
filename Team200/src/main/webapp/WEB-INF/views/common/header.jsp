<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%-- 
  주의: include되는 파일에는 html, head, body 태그를 쓰지 않는다. 
  여기에 적힌 태그들이 부모 페이지의 <body> 태그 안으로 그대로 들어감.
--%>
<header>
	<div class="dropdown" id="mainMenu">
		<div class="header-left">☰ ${not empty headerTitle ? headerTitle : '메인페이지'}
			▾</div>
		<div class="dropdown-content">
			<c:if test="${headerTitle ne '배틀그라운드'}">
				<%-- 폴더명 사진 확인: batterground --%>
				<a href="<c:url value = '/battleground/main' />">배틀그라운드</a>
			</c:if>
			<c:if test="${headerTitle ne '롤'}">
				<a href="<c:url value = '/lol/main' />">리그 오브 레전드</a>
			</c:if>
			<c:if test="${headerTitle ne '오버워치'}">
				<a href="<c:url value = '/overwatch/main' />">오버워치</a>
			</c:if>
			<a href="<c:url value = '/' />" style="border-top: 1px solid #eee;">메인페이지</a>
		</div>
	</div>

	<div class="user-nav">
		<a href="<c:url value = '/member/mypage' />"><span>마이페이지</span></a> 
		<a href="<c:url value = '/member/update' />"><span>개인정보 수정</span> </a>
		<span><b>USER01</b> 님</span>
		<a href="<c:url value = '/member/login' />"><button class="btn-logout">로그아웃</button></a>
	</div>
</header>