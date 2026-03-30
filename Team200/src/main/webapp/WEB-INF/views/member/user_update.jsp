<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/member/user_update/style.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/member/user_update/script.js"></script>
	
    <title>LOG.GG - 개인정보 수정</title>
</head>
<body>

    <div class="profile-container">
        <h1>LOG.GG</h1>
        <h2>개인정보 수정</h2>

		 <form:form modelAttribute="member" action="${pageContext.request.contextPath}/security/update" method="POST">        
            <div class="form-group">
                <div class="label-row"><span class="label">아이디</span></div>
                <sec:authentication property="principal" var="loginUser"/>
                <form:input path="userId" type="text" value="${loginUser.userId}" readonly="readonly" />
                <div class="notice">* 아이디는 변경할 수 없습니다.</div>
            </div>

            <div class="form-group">
                <div class="label-row">
                    <span class="label">현재 비밀번호 확인</span>
                    <button type="button" class="inner-btn" onclick="pwCheck()">확인</button>
                </div>
                <input id="pw" name="initUserPw" type="password" placeholder="정보 수정을 위해 현재 비번 입력" />
            </div>

            <div class="form-group">
                <div class="label-row">
                    <span class="label">닉네임 변경</span>
                    <button type="button" class="inner-btn" onclick="nameCheck()">중복확인</button>
                </div>
                <form:input id="newUsername" path="userName" type="text" placeholder="새로운 닉네임 입력" />
            </div>

            <div class="form-group">
                <div class="label-row">
                    <span class="label">인증 이메일 변경</span>
                    <button type="button" class="inner-btn">인증</button>
                </div>
                <form:input id="email" path="email" type="email" value="old_email@log.gg"/>
            </div>

            <div class="form-group">
                <div class="label-row"><span class="label">새 비밀번호 (변경 시에만 입력)</span></div>
                <form:input id="newPw" path="userPw" type="password" placeholder="중복확인 후 입력가능합니다." disabled="true" />
            </div>

            <button type="submit" class="btn-submit">정보 수정 완료</button>
        </form:form>
        
        <a href="<c:url value='/member/delete'/>" >
		    <div class="withdraw-link">회원 탈퇴하기</div>
		</a>
    </div>
    
    <script>
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
	    function pwCheck(){
	    	// 비밀번호 중복 확인
	    	const $userPw = $("input[name=initUserPw]");

	    	$.ajax({
	    		url : "${pageContext.request.contextPath}/member/pwCheck" ,
	    		data : {
	    			userPw : $userPw.val()
	    		},
	    		success : function(result){
	    			if(result == "1"){
	    				alert("현재 비밀번호와 동일합니다.");
	    				document.getElementById("newPw").disabled = false;
	    			}else{
	    				alert("비밀번호가 틀립니다.");
	    				document.getElementById("newPw").disabled = true;

                        $userPw.val("");
                        document.getElementById("newPw").value = "";
	    				$userPw.focus();
	    			}
	    		}
	    	})
	    }

	    $("form").on("submit", function(e){

	        const newPw = $("#newPw").val();

	        // 새 비밀번호 입력했을 때만 검사
	        if(newPw !== ""){
	            const pwRegex = /^(?=.*[A-Za-z])(?=.*\d).{8,}$/;

	            if(!pwRegex.test(newPw)){
	                alert("새 비밀번호도 영문 + 숫자 포함 8자 이상이어야 합니다.");
	                $("#newPw").focus();
	                e.preventDefault(); // 🔥 제출 막기
	                return false;
	            }
	        }
	    });
    </script>

</body>
</html>