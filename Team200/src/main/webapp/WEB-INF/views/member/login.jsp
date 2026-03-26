<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/member/login/style.css">
	<script src="${pageContext.request.contextPath}/resources/member/login/script.js"></script>
	
<style>
a {
  text-decoration: none;
  color : black;
}
</style>
	<title>로그인</title>
</head>
<body>
    <div class="login-card">
        <h1>LOG.GG</h1>
        	<form:form action="${pageContext.request.contextPath}/member/loginProcess" method="POST">
        	
		        <div class="input-group">
		            <label>아이디</label>
		            <input type="text" name="userId" placeholder="아이디를 입력하세요">
		        </div>
		        
		        <div class="input-group">
		            <label>비밀번호</label>
		            <input type="password" name="userPw" placeholder="비밀번호를 입력하세요">
		        </div>
		        
		        <button class="login-btn">로그인</button>
		        
		    </form:form>
	    
        <div class="links">
        <a href="${pageContext.request.contextPath}/member/idpw">아이디/비밀번호 찾기</a> | 
        <a href="${pageContext.request.contextPath}/member/join">회원가입</a></div>
    </div>
</body>
</html>