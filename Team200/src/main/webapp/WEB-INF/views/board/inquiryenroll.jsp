<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LOG.GG - 1:1 문의 작성</title>
    <style>
        @import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css');

        :root {
            --primary-navy: #475569;
            --accent-blue: #3b82f6;
            --bg-soft: #f8fafc;
            --input-bg: #f1f5f9;
            --border-color: #e2e8f0;
            --container-width: 1440px;
            --sidebar-width: 280px;
        }

        body {
            margin: 0; padding: 0; font-family: 'Pretendard', sans-serif;
            background-color: var(--bg-soft); color: #1e293b;
            width: var(--container-width); margin: 0 auto;
        }

        /* 헤더 스타일 유지 */
        header {
            position: sticky; top: 0; z-index: 100; background: var(--primary-navy);
            padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; height: 40px;
        }
        .header-left { display: flex; align-items: center; gap: 20px; font-weight: 600; color: #ecf0f5; cursor: pointer; }
        .user-nav { display: flex; gap: 20px; align-items: center; font-size: 14px; color: #ecf0f5; }
        .btn-logout { padding: 8px 18px; background: var(--bg-soft); border: none; border-radius: 10px; font-weight: 600; font-size: 13px; cursor: pointer; }

        .main-layout { display: grid; grid-template-columns: var(--sidebar-width) 1fr var(--sidebar-width); gap: 30px; padding: 40px; }

        /* 왼쪽 사이드바 */
        .side-card { background: white; padding: 24px; border-radius: 20px; box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05); }
        .side-card h3 { font-size: 16px; font-weight: 800; margin: 0 0 18px 0; color: var(--primary-navy); display: flex; align-items: center; gap: 10px; }
        .side-card h3::before { content: ''; width: 4px; height: 16px; background: var(--accent-blue); border-radius: 2px; }
        .menu-item { font-weight: 700; color: var(--primary-navy); padding: 10px 0; cursor: pointer; }
        .sub-item { padding: 8px 0 8px 20px; font-size: 14px; color: #64748b; cursor: pointer; }

        /* 작성 카드 (이미지 스타일 재현) */
        .write-card {
            background: white; border-radius: 24px; padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }

        .write-header { font-size: 20px; font-weight: 800; margin-bottom: 30px; display: flex; align-items: center; gap: 8px; }

        .form-group-row { display: flex; gap: 20px; margin-bottom: 20px; }
        .form-item { flex: 1; }
        
        .label { display: block; font-size: 13px; font-weight: 800; color: #64748b; margin-bottom: 8px; }

        input, select, textarea {
            width: 100%; padding: 14px 18px; border: 1px solid var(--border-color);
            border-radius: 12px; background: var(--bg-soft); font-family: inherit;
            font-size: 14px; color: #1e293b; box-sizing: border-box;
        }

        input::placeholder, textarea::placeholder { color: #94a3b8; }
        
        textarea { height: 350px; resize: none; line-height: 1.6; }

        /* 하단 버튼 영역 */
        .form-footer {
            display: flex; justify-content: flex-end; gap: 12px; margin-top: 30px;
        }
        .btn-cancel {
            padding: 12px 30px; background: #f1f5f9; border: none; border-radius: 10px;
            font-weight: 700; color: #64748b; cursor: pointer;
        }
        .btn-submit {
            padding: 12px 30px; background: #334155; border: none; border-radius: 10px;
            font-weight: 700; color: white; cursor: pointer;
        }
    </style>
</head>
<body>

    <header>
        <div class="header-left" onclick="location.href='main.html'">☰ 배틀그라운드 ▾</div>
        <div class="user-nav">
            <span>마이페이지</span>
            <span><b>USER01</b> 님</span>
            <button class="btn-logout">로그아웃</button>
        </div>
    </header>

    <div class="main-layout">
        <aside>
            <div class="side-card">
                <h3>카테고리</h3>
                <div class="menu-item">갤러리</div>
                <div class="menu-item">커뮤니티</div>
                <div class="menu-item">고객지원</div>
                <div class="sub-item" style="color: var(--accent-blue); font-weight: 800;">1:1 문의</div>
            </div>
        </aside>

        <main>
            <div class="write-card">
                <div class="write-header">📝 1:1 문의 작성</div>
                
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