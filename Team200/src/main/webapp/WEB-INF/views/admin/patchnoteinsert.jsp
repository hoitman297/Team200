<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LOG.GG - 패치노트 등록</title>
    <style>
        @import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css');
        
        :root {
            --primary-navy: #475569;
            --bg-light: #f1f5f9;
            --accent-blue: #3b82f6;
            --border-color: #e2e8f0;
            --transition: all 0.3s ease;
            /* 요청하신 해상도 규격 설정 */
            --container-width: 1440px;
            --container-height: 1024px;
        }

        body {
            margin: 0; padding: 0;
            font-family: 'Pretendard', sans-serif;
            background-color: var(--bg-light);
            /* 전체 페이지 크기를 요청한 수치로 고정 및 중앙 정렬 */
            width: var(--container-width);
            min-height: var(--container-height);
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
        }

        header {
            position: sticky; top: 0; z-index: 100;
            background: var(--primary-navy);
            padding: 0 40px;
            display: flex; justify-content: space-between; align-items: center;
            height: 60px; /* 헤더 높이 약간 조정 */
            color: #ecf0f5; font-size: 14px;
            flex-shrink: 0;
        }
        .header-left { font-weight: 600; cursor: pointer; }
        .user-nav { display: flex; gap: 20px; align-items: center; }
        .user-nav b { font-weight: 800; display: flex; align-items: center; gap: 5px; }

        /* [메인 레이아웃] 1440px 최적화 */
        .main-layout {
            display: grid;
            grid-template-columns: 280px 1fr 280px;
            gap: 30px; 
            padding: 40px; 
            box-sizing: border-box;
            flex-grow: 1;
        }

        .side-card {
            background: white; padding: 24px; border-radius: 20px;
            box-shadow: 0 10px 25px -5px rgba(0,0,0,0.05);
            height: fit-content;
        }
        .card-header {
            font-size: 16px; font-weight: 800; margin-bottom: 15px;
            color: var(--primary-navy); display: flex; align-items: center; gap: 10px;
        }
        .card-header::before { content: ''; width: 4px; height: 16px; background: var(--accent-blue); border-radius: 2px; }

        /* [중앙 작성 카드] 1024px 높이에 맞춰 textarea 확장 */
        .register-card {
            background: white; border-radius: 20px;
            box-shadow: 0 10px 30px -5px rgba(0,0,0,0.05);
            padding: 40px; 
            display: flex; flex-direction: column; gap: 25px;
            min-height: 800px; /* 세로 높이 확보 */
        }
        .page-header {
            display: flex; justify-content: space-between; align-items: center;
            border-bottom: 2px solid #f1f5f9; padding-bottom: 20px;
        }
        .page-title { font-size: 24px; font-weight: 900; color: var(--primary-navy); margin: 0; }
        .btn-back {
            font-size: 13px; font-weight: 600; color: #64748b;
            background: #f1f5f9; border: none; padding: 8px 16px; border-radius: 10px; cursor: pointer;
        }

        .input-group { display: flex; flex-direction: column; gap: 12px; }
        .input-group label { font-size: 15px; font-weight: 800; color: var(--primary-navy); }

        .game-selector { display: flex; gap: 15px; }
        .game-option { flex: 1; position: relative; }
        .game-option input { position: absolute; opacity: 0; cursor: pointer; }
        .game-label {
            display: block; padding: 12px; text-align: center; border: 2px solid var(--border-color);
            border-radius: 12px; font-weight: 700; cursor: pointer; transition: var(--transition);
            background: #f8fafc; color: #64748b;
        }
        .game-option input:checked + .game-label {
            border-color: var(--accent-blue); background: #eff6ff; color: var(--accent-blue);
        }

        .title-input {
            border: none; border-bottom: 2px solid #f1f5f9; padding: 12px 5px;
            font-size: 20px; font-weight: 600; outline: none; transition: var(--transition);
        }
        .title-input:focus { border-bottom-color: var(--accent-blue); }

        .content-editor {
            border: 1px solid var(--border-color); border-radius: 15px; padding: 20px;
            background: #fcfdfe;
            flex-grow: 1; /* 남은 세로 공간 차지 */
            display: flex;
        }
        .content-editor textarea {
            width: 100%; min-height: 450px; border: none; resize: none; outline: none;
            background: transparent; font-size: 16px; line-height: 1.6; color: #334155;
        }

        .submit-area { text-align: center; margin-top: 10px; }
        .btn-submit {
            background: var(--primary-navy); color: white; border: none;
            padding: 18px 120px; border-radius: 15px; font-weight: 700;
            font-size: 18px; cursor: pointer; transition: var(--transition);
            box-shadow: 0 10px 20px -5px rgba(71, 85, 105, 0.3);
        }
        .btn-submit:hover { transform: translateY(-3px); background: #334155; }
    </style>
</head>
<body>

    <header>
        <div class="header-left">☰ 메인페이지 ▾</div>
        <div class="user-nav">
            <span>게시글 추가</span>
            <b>⚙️ ADMIN01 님</b>
            <button style="padding: 5px 10px; border-radius: 5px; border: none; cursor: pointer;">로그아웃</button>
        </div>
    </header>

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

                <div class="input-group">
                    <label>대상 게임 선택</label>
                    <div class="game-selector">
                        <label class="game-option">
                            <input type="radio" name="game" value="LOL" checked>
                            <span class="game-label">리그 오브 레전드</span>
                        </label>
                        <label class="game-option">
                            <input type="radio" name="game" value="OW">
                            <span class="game-label">오버워치</span>
                        </label>
                        <label class="game-option">
                            <input type="radio" name="game" value="PUBG">
                            <span class="game-label">배틀그라운드</span>
                        </label>
                    </div>
                </div>

                <div class="input-group">
                    <label>패치노트 제목</label>
                    <input type="text" class="title-input" placeholder="패치 버전 및 핵심 내용을 입력하세요">
                </div>

                <div class="input-group" style="flex-grow: 1;">
                    <label>상세 업데이트 내용</label>
                    <div class="content-editor">
                        <textarea placeholder="밸런스 조정, 신규 콘텐츠, 버그 수정 내역 등을 상세히 입력해 주세요."></textarea>
                    </div>
                </div>

                <div class="submit-area">
                    <button class="btn-submit">패치노트 게시하기</button>
                </div>
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