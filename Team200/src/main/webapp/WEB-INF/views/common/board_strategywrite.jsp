<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%-- 🌟 수정 모드인지 새 글 모드인지 판별 --%>
<c:set var="isEdit" value="${not empty board}" />
<c:choose>
    <c:when test="${isEdit}">
        <c:set var="actionUrl" value="/board/update" />
    </c:when>
    <c:otherwise>
        <c:set var="actionUrl" value="/board/${tempBoardType}_write_${gameId}" />
    </c:otherwise>
</c:choose>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/board_write/style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/board/board_write/script.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/${gameThemeCss}">
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>

    <title>LOG.GG - ${gameName} ${isEdit ? '공략 수정' : '공략 작성'}</title>
</head>
<body>
    <c:set var="headerTitle" value="${gameName}" />

    <%@ include file="../common/header.jsp" %>

    <div class="main-layout">
        <aside class="side-left">
            <%@ include file="../common/sidebar.jsp" %>
        </aside>

        <main class="content-area">
            <a href="<c:url value='/'/>"><div class="logo">LOG.GG</div></a>

            <div class="write-container">
                <div class="category-fixed-bar">
                    <span class="category-tag">${isEdit ? '수정 중' : '작성 중'}</span>
                    <span class="category-text" id="targetGame">
                        ${gameName} &gt; ${tempBoardType == 'strategy' ? '공략 게시판' : '자유 게시판'}
                    </span>
                </div>

                <div class="write-header">
                    <h2>${isEdit ? '공략 수정하기' : '새 공략 작성하기'}</h2>
                </div>
                
                <%-- ✅ action 경로에 CSRF 토큰 포함 및 POST 방식 확인 --%>
                <form id="writeForm" action="<c:url value='${actionUrl}?${_csrf.parameterName}=${_csrf.token}'/>" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    
                    <%-- 🌟 수정 시 반드시 필요한 게시글 번호 --%>
                    <c:if test="${isEdit}">
                        <input type="hidden" name="boardNo" value="${board.boardNo}" />
                    </c:if>

                    <div class="form-group">
                        <label>제목</label> 
                        <%-- 🌟 [수정포인트] name을 VO 필드명인 'boardTitle'로 변경 --%>
                        <input type="text" name="boardTitle" value="${board.boardTitle}" placeholder="공략 제목을 입력해 주세요" required>
                    </div>

                    <div class="form-group">
                        <label>내용</label>
                        <%-- 🌟 [수정포인트] name을 VO 필드명인 'boardContent'로 변경 --%>
                        <textarea class="editor-area" name="boardContent" rows="15" placeholder="나만의 꿀팁과 공략을 공유해 주세요! (비방/욕설 금지)" required>${board.boardContent}</textarea>

                        <div class="file-upload">
                            <%-- 🌟 기존 첨부파일 목록 및 삭제 UI --%>
                            <c:if test="${isEdit and not empty board.fileList}">
                                <div class="existing-files" style="margin-top: 15px; margin-bottom: 15px; padding: 15px; background: #f8fafc; border-radius: 8px; border: 1px solid #e2e8f0;">
                                    <p style="margin: 0 0 10px 0; font-weight: bold; font-size: 14px; color: #ef4444;">
                                        🗑️ 삭제할 기존 파일을 체크해 주세요.
                                    </p>
                                    <c:forEach var="file" items="${board.fileList}">
                                        <div style="margin-bottom: 5px; font-size: 14px; display: flex; align-items: center;">
                                            <label style="cursor: pointer; display: flex; align-items: center; gap: 8px;">
                                                <input type="checkbox" name="deleteFileNos" value="${file.fileNo}">
                                                <span style="color: #475569;">${file.originName}</span>
                                            </label>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>

                            <p style="margin: 0 0 10px 0; font-weight: bold; font-size: 14px; color: #334155;">📎 새 파일 추가</p>
                            <input type="file" name="upFile" multiple style="margin-bottom: 10px;"> <br> 
                            <span style="font-size: 13px; color: #64748b;">공략에 필요한 이미지나 파일을 첨부할 수 있습니다.</span>
                        </div>
                    </div>

                    <div class="write-footer">
                        <button type="button" class="btn btn-cancel" onclick="history.back()">취소</button>
                        <button type="submit" class="btn btn-submit">${isEdit ? '수정완료' : '등록하기'}</button>
                    </div>
                </form>
            </div>
        </main>

        <aside class="side-right">
            <div class="side-card" style="background: #cbd5e1; min-height: 200px;">
                <h3>공략 게시판 이용 수칙</h3>
                <p style="font-size: 14px; color: #475569; line-height: 1.7; font-weight: 500;">
                    ${boardNotice}<br><br>
                    허위 정보나 도배글은 제재 대상이 될 수 있습니다.<br>
                    유익한 정보 공유를 부탁드립니다!
                </p>
            </div>
        </aside>
    </div>

    <footer>© 2026 LOG.GG ${gameName} 서비스. 모든 권리 보유.</footer>
</body>
</html>