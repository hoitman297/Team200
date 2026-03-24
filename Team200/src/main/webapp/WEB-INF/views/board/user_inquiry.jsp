<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/user_inquiry/style.css">
	<script src="${pageContext.request.contextPath}/resources/board/user_inquiry/script.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
	<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
	
    <title>LOG.GG - 1:1 문의</title>
</head>
<body>
	<c:set var="headerTitle" value="게시판" />
    <%@ include file="../common/header.jsp" %>

    <div class="main-layout">
        <aside class="side-left">
            <div class="side-card">
                <h3>카테고리</h3>
                <a href="<c:url value = '/gallery/list' />"><div class="menu-item">갤러리</div></a>
                
                <div class="menu-item-group">
                    <div class="menu-item">게시판</div>
                    <div class="sub-menu-container">
                        <a href="<c:url value = '/board/free' />"><div class="sub-item">자유게시판</div></a>
                        <a href="<c:url value = '/board/strategy' />"><div class="sub-item">공략게시판</div></a>
                    </div>
                </div>
                <a href="<c:url value = '/board/inquiry' />"><div class="menu-item">고객지원</div></a>
            </div>
        </aside>

        <main class="content-area">
            <div class="logo">LOG.GG</div>
            
            <div class="content-card">
                <div class="board-header">
                    <h2 class="board-title">1:1 문의 내역</h2>
                    <button class="btn-write" onclick="location.href='qna-write.html'">문의하기</button>
                </div>

                <table class="qna-table">
                    <thead>
                        <tr>
                            <th width="80">번호</th>
                            <th>제목</th>
                            <th width="120">작성자</th>
                            <th width="120">날짜</th>
                            <th width="120">상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>003</td>
                            <td class="title-td">로그인 오류가 계속 발생합니다.</td>
                            <td>USER01</td>
                            <td>25-03-09</td>
                            <td><span class="status-badge waiting">답변대기</span></td>
                        </tr>
                        <tr>
                            <td>002</td>
                            <td class="title-td private-text">
                                <span class="lock-icon">🔒</span> 비공개 문의글입니다.
                            </td>
                            <td>user***</td>
                            <td>25-03-08</td>
                            <td><span class="status-badge completed">답변완료</span></td>
                        </tr>
                        <tr>
                            <td>001</td>
                            <td class="title-td">아이템 복구 관련 문의드립니다.</td>
                            <td>USER01</td>
                            <td>25-03-07</td>
                            <td><span class="status-badge completed">답변완료</span></td>
                        </tr>
                    </tbody>
                </table>

                <div class="pagination">
                    <button class="page-btn">이전</button>
                    <button class="page-btn active">1</button>
                    <button class="page-btn">2</button>
                    <button class="page-btn">3</button>
                    <button class="page-btn">다음</button>
                </div>
            </div>
        </main>

        <aside class="side-right">
            <div class="side-card" style="background: #cbd5e1; min-height: 200px;">
                <h3>문의 안내</h3>
                <p style="font-size: 14px; color: #475569; line-height: 1.7; font-weight: 500;">
                    • 평일: 09:00 ~ 18:00<br>
                    • 주말/공휴일 휴무<br><br>
                    문의하신 내용은 관리자 확인 후 순차적으로 답변드립니다.
                </p>
            </div>
        </aside>
    </div>

    <footer>© 2026 LOG.GG 배틀그라운드 서비스. 모든 권리 보유.</footer>

</body>
</html>