<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LOG.GG - 공지사항 등록 (1440x1024)</title>
    <style>
        @import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css');
        
        :root {
            --primary-navy: #475569;
            --bg-light: #f1f5f9; 
            --accent-blue: #3b82f6;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            /* 해상도 고정값 설정 */
            --width-fix: 1440px;
            --height-fix: 1024px;
        }

        body {
            margin: 0; padding: 0;
            font-family: 'Pretendard', sans-serif;
            background-color: var(--bg-light);
            /* 1440x1024 규격 고정 */
            width: var(--width-fix);
            min-height: var(--height-fix);
            margin: 0 auto;
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
        }

        /* 헤더 영역 */
        header {
            position: sticky; top: 0; z-index: 100;
            background: var(--primary-navy);
            padding: 0 40px;
            display: flex; justify-content: space-between; align-items: center;
            height: 60px; color: #ecf0f5; font-size: 14px;
        }
        .header-left { display: flex; align-items: center; gap: 10px; cursor: pointer; font-weight: 600; }
        .user-nav { display: flex; gap: 20px; align-items: center; }
        .user-nav span { cursor: pointer; opacity: 0.8; transition: var(--transition); }
        .user-nav span:hover { opacity: 1; }
        .user-nav b { font-weight: 800; font-size: 15px; display: flex; align-items: center; gap: 5px; }

        .btn-logout {
            padding: 8px 18px; background: white; border: none; border-radius: 10px;
            font-weight: 600; cursor: pointer; transition: var(--transition);
            color: var(--primary-navy);
        }

        /* 메인 레이아웃 (3컬럼 고정) */
        .main-layout {
            display: grid;
            grid-template-columns: 280px 1fr 320px;
            gap: 30px; 
            padding: 40px; 
            box-sizing: border-box;
            flex: 1; /* 남은 높이 채움 */
        }

        /* 사이드 카드 공통 */
        .side-card {
            background: white; padding: 24px;
            border-radius: 20px; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.05);
        }
        .card-header {
            font-size: 16px; font-weight: 800; margin-bottom: 18px;
            display: flex; align-items: center; justify-content: space-between;
        }
        .card-header span { display: flex; align-items: center; gap: 10px; color: var(--primary-navy); }
        .card-header span::before { content: ''; width: 4px; height: 16px; background: var(--accent-blue); border-radius: 2px; }

        /* 중앙 등록 카드 영역 */
        .register-card {
            background: white; border-radius: 20px;
            box-shadow: 0 10px 30px -5px rgba(0,0,0,0.05);
            padding: 40px; display: flex; flex-direction: column; gap: 25px;
            height: fit-content;
        }

        .page-header {
            display: flex; justify-content: space-between; align-items: center;
            border-bottom: 2px solid #f1f5f9; padding-bottom: 20px;
        }
        .page-title { font-size: 22px; font-weight: 900; color: var(--primary-navy); margin: 0; }

        .btn-back {
            font-size: 13px; font-weight: 600; color: #64748b;
            background: #f1f5f9; border: none; padding: 8px 16px; border-radius: 10px; cursor: pointer;
        }

        /* 폼 입력 요소 */
        .input-group { display: flex; flex-direction: column; gap: 10px; }
        .input-group label { font-size: 14px; font-weight: 800; color: var(--primary-navy); display: flex; align-items: center; gap: 8px; }
        .input-group label::before { content: '•'; color: var(--primary-navy); }

        .category-select {
            width: 180px; padding: 10px 15px; border-radius: 12px;
            border: 1px solid #e2e8f0; background: #f8fafc;
            font-weight: 600; color: #475569; outline: none;
        }

        .title-input {
            border: none; border-bottom: 2px solid #f1f5f9; padding: 10px 5px;
            font-size: 18px; font-weight: 600; outline: none;
        }

        .content-editor {
            border: 1px solid #e2e8f0; border-radius: 15px; padding: 20px;
            background: #fcfdfe;
        }
        .content-editor textarea {
            width: 100%; 
            height: 550px; /* 고정 높이에 맞춰 텍스트 영역 확장 */
            border: none; resize: none; outline: none;
            background: transparent; font-size: 16px; line-height: 1.6; color: #334155;
        }

        /* 하단 등록 버튼 */
        .submit-area { text-align: center; margin-top: 10px; }
        .btn-submit {
            background: var(--primary-navy);
            color: white; border: none;
            padding: 18px 100px; border-radius: 15px; font-weight: 700;
            font-size: 16px; cursor: pointer; transition: var(--transition);
        }
        .btn-submit:hover { background: #334155; transform: translateY(-2px); }

        /* 우측 사이드바 */
        .notice-card { background: #cbd5e1; border-radius: 20px; padding: 25px; }
        .notice-list { list-style: none; padding: 0; margin: 0; font-size: 14px; color: #475569; line-height: 2.2; }
    </style>
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