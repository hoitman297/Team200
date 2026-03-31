<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/member/user_delete_pop/style.css">
	<script src="${pageContext.request.contextPath}/resources/member/user_delete_pop/script.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/member/user_delete_pop/style.css?v=1.1">
	<script src="${pageContext.request.contextPath}/resources/member/user_delete_pop/script.js?v=1.1"></script>
    <title>LOG.GG - 회원 탈퇴</title>
</head>
<body>

    <div class="withdrawal-container">
        <div class="withdrawal-card">
            <span class="icon-warning">⚠️</span>
            <h2>정말로 탈퇴하시겠어요?</h2>
            <p class="sub-text">탈퇴하시면 LOG.GG의 모든 데이터가 삭제됩니다.</p>

            <div class="warning-box">
                <h3>유의사항 확인</h3>
                <ul class="warning-list">
                    <li>계정 삭제 시 복구는 불가능합니다.</li>
                    <li>작성하신 게시물 및 댓글은 자동으로 삭제되지 않습니다.</li>
                    <li>탈퇴 후 30일간 동일한 이메일로 재가입이 제한됩니다.</li>
                </ul> 
            </div>

            <label class="confirm-area" id="checkLabel">
                <input type="checkbox" id="withdrawCheck">
                안내 사항을 모두 확인하였으며, 이에 동의합니다.
            </label>

            <div class="btn-group">
    <button type="button" class="btn btn-cancel" onclick="history.back()">취소</button>
    <button type="button" 
            class="btn btn-submit" 
            id="submitBtn" 
            disabled 
            data-url="<c:url value='/member/delete' />">회원 탈퇴</button>
			</div>
                <button class="btn btn-cancel" onclick="history.back()">취소</button>
                <button class="btn btn-submit"  id="submitBtn" onclick="location.href='../마이페이지/회원탈퇴2.html'">회원 탈퇴</button>
            </div>
        </div>
    </div>
</body>
</html>