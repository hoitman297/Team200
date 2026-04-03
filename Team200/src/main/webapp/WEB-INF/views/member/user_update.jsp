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
    <sec:authentication property="principal" var="loginUser"/>
    
    <title>LOG.GG - 개인정보 수정</title>
</head>
<body>

    <div class="profile-container">
        <h1>LOG.GG</h1>
        <h2>개인정보 수정</h2>

         <form:form id="updateForm" modelAttribute="member" action="${pageContext.request.contextPath}/security/update" method="POST">        
            <div class="form-group">
                <div class="label-row"><span class="label">아이디</span></div>
                <form:hidden path="userId" value="${loginUser.userId}" />
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
                <form:input id="newUsername" path="userName" type="text" value="${loginUser.userName}" oninput="resetNameCheck()" />
                <span id="nameCheckMsg" class="check-msg"></span>
            </div>

            <div class="form-group">
                <div class="label-row">
                    <span class="label">인증 이메일 변경</span>
                    <button type="button" class="inner-btn">인증</button>
                </div>
                <form:input id="email" path="email" type="email" value="${loginUser.email}" />
            </div>

            <div class="form-group">
                <div class="label-row"><span class="label">새 비밀번호 (변경 시에만 입력)</span></div>
                <form:input id="newPw" path="userPw" type="password" placeholder="중복확인 후 입력가능합니다." disabled="true" />
            </div>

            <button type="submit" class="btn-submit">정보 수정 완료</button>
        </form:form>
        
        <a href="javascript:history.back();" class="btn-back">
            뒤로 가기
        </a>
    </div>
    
    <script>
        // 처음엔 본인 닉네임이니까 true로 시작!
        let isNameChecked = true; 

        // 닉네임을 타이핑해서 수정하면 실행되는 함수
        function resetNameCheck() {
            isNameChecked = false;
            $("#nameCheckMsg").text("닉네임이 변경되었습니다. 중복 확인을 진행해주세요.").removeClass("valid").addClass("invalid");
        }

        function nameCheck(){
            // 닉네임 중복 확인
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
                        alert("이미 사용중인 닉네임입니다.");
                        $userName.focus();
                        isNameChecked = false;
                    }else{
                        alert("사용해도 됩니다.");
                        isNameChecked = true;
                        $("#nameCheckMsg").text("").removeClass("invalid"); // 경고 메시지 지우기
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
                        alert("현재 비밀번호와 일치합니다."); // 문맥상 '일치합니다'가 자연스러워 살짝 바꿨어요!
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

        // 폼 제출(Submit) 시 최종 검사
        $("form").on("submit", function(e){
            // 1. 닉네임 중복확인 안 했으면 막기!
            if (!isNameChecked) {
                $("#nameCheckMsg").text("닉네임 중복 확인 버튼을 눌러주세요.").addClass("invalid");
                $("#newUsername").focus();
                e.preventDefault(); // 제출 막기
                return false;
            }

            // 2. 새 비밀번호 유효성 검사
            const newPw = $("#newPw").val();
            if(newPw !== ""){
                const pwRegex = /^(?=.*[A-Za-z])(?=.*\d).{8,}$/;

                if(!pwRegex.test(newPw)){
                    alert("새 비밀번호도 영문 + 숫자 포함 8자 이상이어야 합니다.");
                    $("#newPw").focus();
                    e.preventDefault(); // 제출 막기
                    return false;
                }
            }
        });
    </script>
</body>
</html>