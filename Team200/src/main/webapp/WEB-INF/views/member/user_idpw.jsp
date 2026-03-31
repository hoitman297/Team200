<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/member/user_idpw/style.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/member/user_idpw/script.js"></script>

	<meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>LOG.GG - 아이디/비밀번호 찾기</title>
</head>
<body>

    <div class="find-card">
        <div class="logo">LOG.GG</div>

        <div class="tab-group">
            <div id="tab-id" class="tab active" onclick="switchTab('id')">아이디 찾기</div>
            <div id="tab-pw" class="tab" onclick="switchTab('pw')">비밀번호 찾기</div>
        </div>

        <div id="section-id" class="find-section active">
            <p class="info-text">가입 시 등록한 이름과 이메일을 입력하세요.</p>
            <form:form modelAttribute="member" action="${pageContext.request.contextPath}/member/idpw_id" method="POST">
	            <div class="form-group">
	                <label>닉네임</label>
	                <form:input path="userName" id="userName1" type="text" placeholder="닉네임을 입력하세요" required="true"/>
	            </div>
	            <div class="form-group">
	                <label>이메일</label>
	                <form:input path="email" id="email1" type="email" placeholder="example@log.gg" required="true"/>
	            </div>
	            <div>
            		<p>회원님의 아이디는 [<strong id="ID_RESULT"></strong>] 입니다.</p>
            	</div>
	         	   <button type="button" class="btn-main" onclick="findId()">아이디 찾기</button>
            </form:form>
        </div>

        <div id="section-pw" class="find-section">
            <p class="info-text">비밀번호 재설정을 위해 정보를 입력하세요.</p>
            <form:form modelAttribute="member" action="${pageContext.request.contextPath}/member/idpw_pw" method="POST">
		            <div class="form-group">
		                <label>아이디</label>
		                <form:input path="userId" id="userId1" type="text" placeholder="아이디를 입력하세요" required="true"/>
		            </div>
		            <div class="form-group">
		                <label>이름</label>
		                <form:input path="userName" id="userName2" type="text" placeholder="닉네임을 입력하세요" required="true"/>
		            </div>
		            <div class="form-group">
		                <label>가입 이메일</label>
		                <form:input path="email" id="email2" type="email" placeholder="example@log.gg" required="true"/>
		            </div>
		            <div>
		            	<p>임시 비밀번호를 발급받습니다. 발급받으신 후 변경 부탁드립니다</p>
		            	<p>회원님의 임시비밀번호는 [<strong id="PW_RESULT"></strong>] 입니다.</p>
		            </div>
          	  <button type="button" class="btn-main" onclick="findPw()">비밀번호 찾기</button>
            </form:form>
        </div>

        <div class="footer-link">
            <a href="${pageContext.request.contextPath}/member/login">로그인 화면으로 돌아가기</a>
        </div>
    </div>

<!--     <script src="/Front/JS/마이페이지/로그인관련/아이디비번찾기.js"></script> -->
    
    <script>
    	function findId(){	
    		const token = $("meta[name='_csrf']").attr("content");
    	    const header = $("meta[name='_csrf_header']").attr("content");
    		// 아이디 찾기 탭의 입력값만 가져오기 위해 ID 선택자(#) 사용
    		const userName = $("#userName1").val();
            const email = $("#email1").val();
    		
    		$.ajax({
    			url : "${pageContext.request.contextPath}/member/idpw_id" ,
    			type : "POST",
    			beforeSend : function(xhr) {
    	            // 헤더에 CSRF 토큰을 실어서 보냄
    	            xhr.setRequestHeader(header, token);
    	        },
    			data : {
    				userName: userName,
                    email: email
    			},
    			success : function(result){
					if(result != ""){
						$("#ID_RESULT").text(result);
					}else{
						alert("일치하는 회원 정보가 없습니다.");
						$("#ID_RESULT").text("");
					}	
				},
				error : function(){
					alert("서버 통신 오류 발생")
				}
    		});
    	}
    	
    	function findPw(){
    		const token = $("meta[name='_csrf']").attr("content");
    	    const header = $("meta[name='_csrf_header']").attr("content");
    		// 비밀번호 찾기 탭의 입력값 가져오기
    		const userId = $("#userId1").val();
            const userName = $("#userName2").val();
            const email = $("#email2").val();
    		
    		$.ajax({
    			url : "${pageContext.request.contextPath}/member/idpw_pw" ,
    			type : "POST",
    			beforeSend : function(xhr) {
    	            xhr.setRequestHeader(header, token);
    	        },
    			data : {
    				userId: userId,
                    userName: userName,
                    email: email
    			},
    			success : function(result){
    				if (result !== "") {
                        $("#PW_RESULT").text(result);
                    } else {
                        alert("일치하는 정보가 없습니다.");
                        $("#PW_RESULT").text("");
                    }	
				},
    			error: function() {
                    alert("서버 통신 오류 발생");
                }
    		});
    	}
    </script>

</body>
</html>