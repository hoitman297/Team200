<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/member/login/style.css">
	<script src="${pageContext.request.contextPath}/resources/member/login/script.js"></script>
	
	<!-- alertify -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
	<!-- alertify css -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css"/>
	<!-- Default theme -->
	<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.css"/>
	
	<title>로그인</title>
	
<c:if test="${param.error != null}">
<script>
        // DOM이 완전히 로드된 후 실행되도록 document.ready를 사용합니다.
        $(document).ready(function() {
            toastr.options = {
                "progressBar": true,
                "positionClass": "toast-top-right", // 위치 지정
                "timeOut": "1500"
            };
            // ⚠️ 주의: toastr.error(메시지, 타이틀) 순서입니다.
            toastr.error("${alertMsg}", "로그인 실패");
        });
    </script>
</c:if>

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