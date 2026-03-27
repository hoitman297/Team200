<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/admin/admin_patchnotes/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    
    <title>LOG.GG - 패치노트 등록</title>
    <%@ include file="../common/header.jsp"%>
</head>
<body>

    <div class="main-layout">
        <aside>
            <div class="side-card">
                <div class="card-header">작성 가이드</div>
                <p style="font-size: 13px; color: #64748b; line-height: 1.8;">
                    각 게임의 버전을 반드시 기입하세요.<br>
                    주요 변경 사항은 볼드 처리를 권장합니다.<br>
                    이미지는 드래그 & 드롭으로 삽입 가능합니다.
                </p>
            </div>
        </aside>

        <main>
            <div class="register-card">
                <div class="page-header">
                    <h2 class="page-title">패치노트 등록</h2>
                    <button class="btn-back">← 목록으로</button>
                </div>
                
		<form:form modelAttribute="patchnote" action="patchnote" method="POST">
                <div class="input-group">
                    <label>대상 게임 선택</label>
                    <div class="game-selector">
                        <label class="game-option">
                            <form:radiobutton path="gameCode" value="LOL" />
                            <span class="game-label">리그 오브 레전드</span>
                        </label>
                        <label class="game-option">
                            <form:radiobutton path="gameCode" value="OW"/>
                            <span class="game-label">오버워치</span>
                        </label>
                        <label class="game-option">
                            <form:radiobutton path="gameCode" value="BG"/>
                            <span class="game-label">배틀그라운드</span>
                        </label>
                    </div>
                </div>
		
                <div class="input-group">
                    <label>패치노트 제목</label>
               			<form:input path="title" type="text" class="title-input" placeholder="패치 버전 및 핵심 내용을 입력하세요" />
                </div>

                <div class="input-group" style="flex-grow: 1;">
                    <label>상세 업데이트 내용</label>
                    <div class="content-editor">
                		<form:textarea path="patchnoteContent" placeholder="밸런스 조정, 신규 콘텐츠, 버그 수정 내역 등을 상세히 입력해 주세요."/>
                    </div>
                </div>

                <div class="submit-area">
                    <button class="btn-submit">패치노트 게시하기</button>
                </div>
        </form:form>
            </div>
        </main>

        <aside>
            <div class="side-card" style="background: #cbd5e1;">
                <div class="card-header" style="color: #1e293b;">최근 등록 리스트</div>
                <ul style="list-style: none; padding: 0; font-size: 14px; color: #475569; line-height: 2.2;">
                    <li>[오버워치] 밸런스 패치 2.0.1</li>
                    <li>[배그] 맵 로테이션 공지</li>
                    <li>[롤] 14.5 패치 미리보기</li>
                    <li>[롤] 아레나 모드 조정</li>
                </ul>
            </div>
        </aside>
    </div>
</body>
</html>