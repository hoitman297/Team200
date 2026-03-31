<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%-- ✨ 추가: 이전 페이지에서 넘어온 game 값을 읽어서 변수에 저장합니다! --%>
<c:set var="currentGame" value="${empty param.game ? 'all' : param.game}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/user_inquiry_write/style.css">
    <script src="${pageContext.request.contextPath}/resources/board/user_inquiry_write/script.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
    
    <title>LOG.GG - 1:1 문의 작성</title>
</head>
<body>
    <c:set var="headerTitle" value="고객지원" />
    <%@ include file="../common/header.jsp" %>

    <div class="main-layout">
        <aside class="side-left">
             <%@ include file="../common/sidebar.jsp" %>
        </aside>

        <main class="content-area">
            <div class="write-card" style="background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
                <div class="write-header" style="font-size: 20px; font-weight: bold; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 2px solid #e2e8f0;">📝 문의 작성</div>
                
                <form id="qnaForm" action="<c:url value='/board/inquiry/insert' />" method="POST">
                	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                	
                    <div class="form-group-row" style="display: flex; gap: 20px; margin-bottom: 20px;">
                        <div class="form-item" style="flex: 1;">
                            <label class="label" style="display: block; margin-bottom: 8px; font-weight: 500;">문의 사유</label>
                            <select name="reason" style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px;">
                                <option value="report">사용자 신고 관련</option>
                                <option value="account">계정/로그인 문의</option>
                                <option value="etc">기타 문의</option>
                            </select>
                        </div>
                        
                        <%-- ✨ 수정된 부분: 읽기 전용 텍스트에서 선택 가능한 드롭다운으로 변경! --%>
                        <div class="form-item" style="flex: 1;">
                            <label class="label" style="display: block; margin-bottom: 8px; font-weight: 500;">게임 분류</label>
                            <select name="gameCode" style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px;">
                                <%-- 넘어온 게임 파라미터와 일치하면 자동으로 selected(선택) 되게 해주는 마법의 EL 표현식! --%>
                                <option value="all" ${currentGame == 'all' ? 'selected' : ''}>전체/기타</option>
                                <option value="battleground" ${currentGame == 'battleground' ? 'selected' : ''}>배틀그라운드</option>
                                <option value="lol" ${currentGame == 'lol' ? 'selected' : ''}>리그 오브 레전드</option>
                                <option value="overwatch" ${currentGame == 'overwatch' ? 'selected' : ''}>오버워치</option>
                            </select>
                        </div>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <label class="label" style="display: block; margin-bottom: 8px; font-weight: 500;">제목</label>
                        <input type="text" name="boardTitle" placeholder="문의 제목을 입력해주세요." style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; box-sizing: border-box;">
                    </div>

                    <div style="margin-bottom: 20px;">
                        <label class="label" style="display: block; margin-bottom: 8px; font-weight: 500;">문의 내용</label>
                        <textarea name="boardContent" placeholder="내용을 상세히 적어주시면 더 빠른 답변이 가능합니다." style="width: 100%; height: 200px; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; box-sizing: border-box; resize: vertical;"></textarea>
                    </div>

                    <div class="form-footer" style="display: flex; justify-content: flex-end; gap: 10px;">
                        <button type="button" class="btn-cancel" onclick="history.back()" style="padding: 10px 20px; border: 1px solid #cbd5e1; background: white; border-radius: 6px; cursor: pointer;">취소</button>
                        <button type="submit" class="btn-submit" style="padding: 10px 20px; border: none; background: #3b82f6; color: white; border-radius: 6px; cursor: pointer; font-weight: bold;">문의하기</button>
                    </div>
                </form>
            </div>
        </main>

        <aside class="side-right">
            <div class="side-card" style="background: #cbd5e1; min-height: 150px; padding: 20px; border-radius: 12px;">
                <p style="font-size: 13px; color: #475569; font-weight: 500; line-height: 1.6;">
                    이미지 업로드가 필요한 경우 문의 내용 하단에 링크를 첨부해주세요.
                </p>
            </div>
        </aside>
    </div>

</body>
</html>