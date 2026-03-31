<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/member/user_delete/style.css">
	<script src="${pageContext.request.contextPath}/resources/member/user_delete/script.js"></script>
    
    <title>LOG.GG - 본인 확인</title>
</head>
<body>

    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h2>본인 확인</h2>
                <p>안전한 탈퇴를 위해<br>가입 정보를 다시 한번 입력해 주세요.</p>
            </div>

            <form:form modelAttribute="member" id="withdrawalAuthForm" 
            action="${pageContext.request.contextPath}/security/delete" method="POST">
                <div class="form-group">
                    <label>아이디</label>
                    <sec:authentication property="principal" var="member"/>
					<input type="text" value="${member.userId}" readonly />
                </div>

                <div class="form-group">
                    <label>비밀번호</label>
                    <form:input path="userPw" type="password" placeholder="비밀번호를 입력하세요" required="required" />
                </div>

                <div class="form-group">
                    <label>이메일 인증</label>
                    <div class="email-auth-row">
                        <input type="email" placeholder="email@example.com">
                        <button type="button" class="btn-verify" onclick="sendCode()">인증 요청</button>
                    </div>
                    <input type="text" placeholder="인증번호 6자리 입력">
                </div>

                <button type="submit" class="btn-submit">인증 및 탈퇴 완료</button>
                <button type="button" class="btn-back" onclick="history.back()">이전 단계로 돌아가기</button>
            </form:form>
        </div>
    </div>

    <script src="/Front/JS/마이페이지/로그인관련/script.js"></script>
    
    <script>
			
    </script>

</body>
</html>