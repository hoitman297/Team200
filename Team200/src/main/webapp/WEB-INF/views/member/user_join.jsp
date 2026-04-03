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
    /* 새로 추가된 검증 메시지 스타일 (팝업 대신 띄울 글씨) */
    .check-msg {
        display: block;
        font-size: 13px;
        margin-top: 5px;
        margin-left: 10px;
        font-weight: 600;
    }
    .check-msg.valid { color: #007bff; /* 파란색 */ }
    .check-msg.invalid { color: #dc3545; /* 빨간색 */ }
</style>
    
    <title>LOG.GG - 회원가입</title>
</head>
<body>

    <div class="signup-container">
        <h1>LOG.GG</h1>
        <h2>회원정보를 입력해주세요</h2>
        
        <form:form modelAttribute="member" action="${pageContext.request.contextPath}/security/join" method="POST" onsubmit="return validateForm();">
            <div class="form-group">
                <div class="label-row"><span class="label">아이디 (중복체크)</span>
                <button type="button" class="inner-btn" onclick="idCheck();">확인</button></div>
                <form:input path="userId" type="text" placeholder="아이디 입력" oninput="resetIdCheck()"/>
                <span id="idCheckMsg" class="check-msg"></span>
                <form:errors path="userId" cssClass="error" />
            </div>

            <div class="form-group">
                <div class="label-row"><span class="label">비밀번호</span></div>
                <form:input path="userPw" type="password" placeholder="영문, 숫자 포함 8자 이상" oninput="checkPw()" />
                <form:errors path="userPw" cssClass="error" />
            </div>

            <div class="form-group">
                <div class="label-row"><span class="label">비밀번호 확인</span></div>
                <input type="password" id="userPwConfirm" placeholder="비밀번호 재입력" oninput="checkPw()" />
                <span id="pwCheckMsg" class="check-msg"></span>
            </div>

            <div class="form-group">
                <div class="label-row"><span class="label">인증 이메일</span><button type="button" class="inner-btn">인증하기</button></div>
                <form:input path="email" type="email" placeholder="example@log.gg"/>
                <form:errors path="email" cssClass="error" />
            </div>

            <div class="form-group">
                <div class="label-row"><span class="label">닉네임 (중복체크)</span>
                <button type="button" class="inner-btn" onclick="nameCheck();">확인</button></div>
                <form:input path="userName" type="text" placeholder="사용할 닉네임" oninput="resetNameCheck()" />
                <span id="nameCheckMsg" class="check-msg"></span>
                <form:errors path="userName" cssClass="error" />
            </div>

            <button type="submit" class="btn-submit">가입하기</button>
        </form:form>
    </div>

    <script>
        // 검증 상태를 저장하는 변수
        let isIdChecked = false;
        let isNameChecked = false;

        // 사용자가 아이디 입력값을 수정하면 중복확인 상태 해제
        function resetIdCheck() {
            isIdChecked = false;
            $("#idCheckMsg").text("").removeClass("invalid"); // 기존 경고 문구 지우기
        }

        // 사용자가 닉네임 입력값을 수정하면 중복확인 상태 해제
        function resetNameCheck() {
            isNameChecked = false;
            $("#nameCheckMsg").text("").removeClass("invalid"); // 기존 경고 문구 지우기
        }

        function idCheck(){
            // ID 중복 확인 (원래 코드의 alert 유지)
            const $userId = $("input[name=userId]");
            
            if ($userId.val().trim() === "") {
                alert("아이디를 입력해주세요.");
                $userId.focus();
                return;
            }

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
                        isIdChecked = false;
                    }else{ 
                        alert("사용해도 됩니다.");
                        isIdChecked = true;
                        $("#idCheckMsg").text(""); // 경고 문구가 있었다면 지워줍니다.
                    }
                }
            })
        }
        
        function nameCheck(){
            // 닉네임 중복 확인 (원래 코드의 alert 유지)
            const $userName = $("input[name=userName]");
            
            if ($userName.val().trim() === "") {
                alert("닉네임을 입력해주세요.");
                $userName.focus();
                return;
            }

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
                        isNameChecked = false;
                    }else{
                        alert("사용해도 됩니다.")
                        isNameChecked = true;
                        $("#nameCheckMsg").text(""); // 경고 문구가 있었다면 지워줍니다.
                    }   
                }
            })
        }

        // 팝업창 없이 비밀번호 일치 여부 실시간 확인
        function checkPw() {
            const pw = $("input[name=userPw]").val();
            const pwConfirm = $("#userPwConfirm").val();
            
            if (pwConfirm === "") {
                $("#pwCheckMsg").text("").removeClass("valid invalid");
                return;
            }

            if (pw === pwConfirm) {
                $("#pwCheckMsg").text("비밀번호가 일치합니다.").removeClass("invalid").addClass("valid");
            } else {
                $("#pwCheckMsg").text("비밀번호가 일치하지 않습니다.").removeClass("valid").addClass("invalid");
            }
        }

        // 가입하기 버튼 클릭 시 실행 (확인 버튼을 안 눌렀을 때 글씨 띄우기)
        function validateForm() {
            let isValid = true;

            // 아이디 중복확인을 안 했을 때
            if (!isIdChecked) {
                $("#idCheckMsg").text("아이디 중복 확인 버튼을 눌러주세요.").addClass("invalid");
                isValid = false;
            }

            // 닉네임 중복확인을 안 했을 때
            if (!isNameChecked) {
                $("#nameCheckMsg").text("닉네임 중복 확인 버튼을 눌러주세요.").addClass("invalid");
                isValid = false;
            }

            // 비밀번호가 비어있거나 일치하지 않을 때
            const pw = $("input[name=userPw]").val();
            const pwConfirm = $("#userPwConfirm").val();
            if (pw === "" || pw !== pwConfirm) {
                $("#pwCheckMsg").text("비밀번호가 일치하지 않습니다.").addClass("invalid");
                isValid = false;
            }

            // 하나라도 통과 못하면 false를 반환하여 폼 전송을 막습니다.
            if (!isValid) {
                return false; 
            }

            return true; // 모두 확인되었으면 폼 전송 진행!
        }
    </script>
</body>
</html>