<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/member/user_join/style.css">
	<script src="${pageContext.request.contextPath}/resources/member/user_join/script.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	
<style>
.error{
		color:red;
		font-size: 0.9em;
		margin-left : 10px;
	}
</style>
	
    <title>LOG.GG - 회원가입</title>
</head>
<body>

    <div class="signup-container">
        <h1>LOG.GG</h1>
        <h2>회원정보를 입력해주세요</h2>
        
        <form:form modelAttribute="member" action="${pageContext.request.contextPath}/security/join" method="POST">
            <div class="form-group">
                <div class="label-row"><span class="label">아이디 (중복체크)</span>
                <button type="button" class="inner-btn" onclick="idCheck();">확인</button></div>
                <form:input path="userId" type="text" placeholder="아이디 입력"/>
                <form:errors path="userId" cssClass="error" />
            </div>

            <div class="form-group">
                <div class="label-row"><span class="label">비밀번호</span></div>
                <form:input path="userPw" type="password" placeholder="영문, 숫자 포함 8자 이상" />
                <form:errors path="userPw" cssClass="error" />
            </div>

            <div class="form-group">
                <div class="label-row"><span class="label">비밀번호 확인</span></div>
                <input type="password"placeholder="비밀번호 재입력" />
            </div>

            <div class="form-group">
                <div class="label-row"><span class="label">인증 이메일</span><button type="button" class="inner-btn">인증하기</button></div>
                <form:input path="email" type="email" placeholder="example@log.gg"/>
                <form:errors path="email" cssClass="error" />
            </div>

            <div class="form-group">
                <div class="label-row"><span class="label">닉네임 (중복체크)</span>
                <button type="button" class="inner-btn" onclick="nameCheck();">확인</button></div>
                <form:input path="userName" type="text" placeholder="사용할 닉네임" />
                <form:errors path="userName" cssClass="error" />
            </div>


            <button type="submit" class="btn-submit">가입하기</button>
        </form:form>
    </div>


	<script>
		function idCheck(){
			// ID 중복 확인
			const $userId = $("input[name=userId]");
			
			$.ajax({
				url : "${pageContext.request.contextPath}/member/idCheck" , 
				data : {
					userId : $userId.val()
				},
				success : function(result){
					if(result == 1){ 
						alert("이미 사용중인 아이디입니다.");
						$userId.val("");
						$userId.focus();
					}else{ 
						alert("사용해도 됩니다.");
					}
				}
			})
		}
		
		function nameCheck(){
			// 닉네임 중복 확인
			const $userName = $("input[name=userName]");
			
			$.ajax({
				url : "${pageContext.request.contextPath}/member/nameCheck" ,
				data : {
					userName : $userName.val()
				},
				success : function(result){
					if(result == 1){
						alert("이미 사용중인 닉네임입니다.")
						$userName.val("");
						$userName.focus();
					}else{
						alert("사용해도 됩니다.")
					}	
				}
			})
		}
	</script>
</body>
</html>