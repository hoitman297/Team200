<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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

    <title>LOG.GG - ${gameName} 공략 작성</title>
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
                    <span class="category-tag">작성 중</span>
                    <span class="category-text" id="targetGame">
                        ${gameName} &gt; ${tempBoardType == 'strategy' ? '공략 게시판' : '자유 게시판'}
                    </span>
                </div>

                <div class="write-header">
                    <h2>새 공략 작성하기</h2>
                </div>

                <%-- 
                   action 경로 주의: 
                   Controller의 @PostMapping("/{boardType}_write_{gameCode}")와 정확히 매칭되어야 합니다.
                   ${gameId}가 비어있을 경우를 대비해 확실히 체크하세요!
                --%>
                <form id="writeForm" action="<c:url value='/board/${tempBoardType}_write_${gameId}'/>" method="POST" enctype="multipart/form-data">
                    
                    <%-- Spring Security 보안 방패 (CSRF 토큰) --%>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                    <div class="form-group">
                        <label>제목</label>
                        <input type="text" name="title" placeholder="공략 제목을 입력해 주세요" required>
                    </div>

                    <div class="form-group">
                        <label>내용</label>
                        <textarea class="editor-area" name="content" rows="15" placeholder="나만의 꿀팁과 공략을 공유해 주세요! (비방/욕설 금지)" required></textarea>
                        
                        <div class="file-upload">
                            <input type="file" name="upFile" multiple style="margin-bottom: 10px;"> <br>
                            📎 공략에 필요한 이미지나 파일을 첨부할 수 있습니다.
                        </div>
                    </div>

                    <div class="write-footer">
                        <button type="button" class="btn btn-cancel" onclick="history.back()">취소</button>
                        <button type="submit" class="btn btn-submit">등록하기</button>
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