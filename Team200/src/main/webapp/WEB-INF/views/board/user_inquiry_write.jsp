<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	<c:set var="headerTitle" value="게시판" />
    <%@ include file="../common/header.jsp" %>

    <div class="main-layout">
        <aside>
            <div class="side-card">
                <h3>카테고리</h3>
                <div class="menu-item">갤러리</div>
                
                <div class="menu-item-group">
                    <div class="menu-item">게시판</div>
                    <div class="sub-menu-container">
                        <div class="sub-item" onclick="location.href='board-free.html'">자유게시판</div>
                        <div class="sub-item" onclick="location.href='board-tip.html'">공략게시판</div>
                    </div>
                </div>
                <a href="<c:url value = '/board/inquiry' />"><div class="menu-item">고객지원</div></a>
            </div>
        </aside>

        <main>
            <div class="write-card">
                <div class="write-header">📝 문의 작성</div>
                
                <form id="qnaForm">
                    <div class="form-group-row">
                        <div class="form-item">
                            <label class="label">문의 사유</label>
                            <select>
                                <option>사용자 신고 관련</option>
                                <option>계정/로그인 문의</option>
                                <option>기타 문의</option>
                            </select>
                        </div>
                        <div class="form-item">
                            <label class="label">게임 분류</label>
                            <input type="text" value="기타(전체)" readonly style="background: #e2e8f0; cursor: not-allowed;">
                        </div>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <label class="label">제목</label>
                        <input type="text" placeholder="문의 제목을 입력해주세요.">
                    </div>

                    <div>
                        <label class="label">문의 내용</label>
                        <textarea placeholder="내용을 상세히 적어주시면 더 빠른 답변이 가능합니다."></textarea>
                    </div>

                    <div class="form-footer">
                        <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                        <button type="submit" class="btn-submit">문의하기</button>
                    </div>
                </form>
            </div>
        </main>

        <aside>
            <div class="side-card" style="background: #cbd5e1; min-height: 150px;">
                <p style="font-size: 13px; color: #475569; font-weight: 500;">
                    이미지 업로드가 필요한 경우 문의 내용 하단에 링크를 첨부해주세요.
                </p>
            </div>
        </aside>
    </div>

</body>
</html>