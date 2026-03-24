<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/gallery/gallery_write/style.css">
	<script src="${pageContext.request.contextPath}/resources/gallery/gallery_write/script.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
	<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
	
    <title>LOG.GG - 미디어 업로드</title>
</head>
<body>

    <c:set var="headerTitle" value="갤러리" />
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

            <div class="write-container">
                <div class="write-header">
                    <h2>사진 / 영상 업로드</h2>
                </div>

                <form id="galleryForm">
                    <div class="form-group">
                        <label class="form-label">제목</label>
                        <input type="text" class="input-title" placeholder="제목을 입력하세요" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">미디어 첨부 <span style="color: var(--point-red);">*필수</span></label>
                        <div class="upload-wrapper" onclick="document.getElementById('fileInput').click()">
                            <div class="upload-dropzone" id="dropzone">
                                <img id="previewImage" src="" alt="미리보기">
                                
                                <div class="upload-placeholder" id="placeholder">
                                    <span>📷</span>
                                    <p>클릭하여 사진이나 영상을 첨부하세요<br><small>(파일이 없으면 등록할 수 없습니다)</small></p>
                                </div>
                            </div>
                            <input type="file" id="fileInput" accept="image/*, video/*" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">간단한 설명</label>
                        <textarea class="editor-area" placeholder="내용을 입력해 주세요."></textarea>
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
                <h3>업로드 가이드</h3>
                <p style="font-size: 14px; color: #475569; line-height: 1.7; font-weight: 500;">
                    • 최대 50MB까지 업로드 가능합니다.<br>
                    • 부적절한 이미지는 사전 예고 없이 삭제될 수 있습니다.<br><br>
                    작성하신 게시물은 갤러리 메인에서 바로 확인 가능합니다.
                </p>
            </div>
        </aside>
    </div>

    <footer>© 2026 LOG.GG 배틀그라운드 서비스. 모든 권리 보유.</footer>
</body>
</html>