<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/admin/admin_notice/style.css">
    
    <title>LOG.GG - 공지사항 등록 (1440x1024)</title>
</head>
<body>
    <header>
        <div class="header-left">☰ 메인페이지 ▾</div>
        <div class="user-nav">
            <span>게시글 추가</span>
            <span>마이페이지</span>
            <span>개인정보 수정</span>
            <b>⚙️ ADMIN01 님</b>
            <button class="btn-logout">로그아웃</button>
        </div>
    </header>

    <div class="main-layout">
        <aside class="side-left">
            <div class="side-card">
                <div class="card-header">
                    <span>게임별 패치노트</span>
                </div>
                <div style="font-weight: 700; color: var(--primary-navy); font-size: 14px; margin-bottom: 5px;">최신 패치 현황</div>
                <p style="font-size: 13px; color: #64748b; margin: 0;">관리 중인 게임 리스트입니다.</p>
            </div>
        </aside>

        <main class="content-area">
            <div class="register-card">
                <div class="page-header">
                    <h2 class="page-title">공지사항 등록</h2>
                    <button class="btn-back" onclick="history.back()">← 목록으로 돌아가기</button>
                </div>

                <div class="input-group">
                    <label>분류 선택</label>
                    <select class="category-select">
                        <option>공지사항</option>
                        <option>점검안내</option>
                        <option>알림</option>
                    </select>
                </div>

                <div class="input-group">
                    <label>공지 제목</label>
                    <input type="text" class="title-input" placeholder="공지사항의 제목을 입력하세요.">
                </div>

                <div class="input-group">
                    <label>본문 내용</label>
                    <div class="content-editor">
                        <textarea placeholder="사용자들에게 전달할 상세 내용을 작성하세요."></textarea>
                    </div>
                </div>

                <div class="submit-area">
                    <button class="btn-submit">공지사항 등록</button>
                </div>
            </div>
        </main>

        <aside class="sidebar-right">
            <div class="notice-card">
                <div class="card-header" style="margin-bottom: 10px;">
                    <span style="color: #1e293b;">최근 등록된 공지</span>
                </div>
                <ul class="notice-list">
                    <li>• 공개 테스트 서버 안내</li>
                    <li>• 웹사이트 업데이트 내역</li>
                    <li>• 커뮤니티 이용 규칙 필독</li>
                    <li>• 시스템 정기 점검 예고</li>
                </ul>
            </div>
        </aside>
    </div>
</body>
</html>