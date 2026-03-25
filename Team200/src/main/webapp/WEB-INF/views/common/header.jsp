<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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
			<c:if test="${headerTitle ne '리그 오브 레전드'}">
				<a href="<c:url value = '/lol/main' />">리그 오브 레전드</a>
			</c:if>
			<c:if test="${headerTitle ne '오버워치'}">
				<a href="<c:url value = '/overwatch/main' />">오버워치</a>
			</c:if>
			<a href="<c:url value = '/' />" style="border-top: 1px solid #eee;">메인페이지</a>
		</div>
	</div>

	<div class="user-nav">
		<%-- JSTL을 활용한 로그인 상태 분기 처리 --%>
		
<%-- 		<c:choose> --%>
			<%-- 1. 로그인 상태일 때 (세션에 loginUser 정보가 있을 때) --%>
			
<%-- 			<c:when test="${not empty sessionScope.loginUser}"> --%>
			<sec:authorize access="hasAnyRole('ROLE_USER','ROLE_ADMIN')">
				<a href="<c:url value = '/member/mypage' />"><span>마이페이지</span></a>
				<a href="<c:url value = '/member/update' />"><span>개인정보 수정</span></a>
				<%-- 고정된 USER01 대신 세션에 담긴 유저의 아이디나 닉네임을 출력할 수 있어요 --%>
				<span><b><sec:authentication property="principal.userName"/></b> 님</span>
<%-- 				${sessionScope.loginUser.userId} --%>
				<form:form method="post" action="${pageContext.request.contextPath}/member/logout" style="display:inline;">
				    <button type="submit" class="btn-logout">로그아웃</button>
				</form:form>
			</sec:authorize>
<%-- 			</c:when> --%>
			

			
			<%-- 2. 비로그인 상태일 때 (세션에 정보가 없을 때) --%>
<%-- 			<c:otherwise> --%>
			<sec:authorize access="isAnonymous()">
				<a href="<c:url value = '/member/login' />"><button class="btn-login">로그인</button></a>
			</sec:authorize>
<%-- 			</c:otherwise> --%>
<%-- 		</c:choose> --%>
		
	</div>
</header>