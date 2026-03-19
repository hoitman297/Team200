<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LOG.GG - 1:1 문의</title>
    <style>
        @import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css');

        :root {
            --primary-navy: #475569;
            --accent-blue: #3b82f6;
            --bg-soft: #f8fafc;
            --card-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            --container-width: 1440px;
            --sidebar-width: 280px;
            --text-main: #1e293b;
            --text-sub: #64748b;
        }

        body {
            margin: 0; padding: 0; font-family: 'Pretendard', sans-serif;
            background-color: var(--bg-soft); color: var(--text-main);
            width: var(--container-width); margin: 0 auto; line-height: 1.5;
        }

        /* 헤더 스타일 통일 (1440 규격) */
        header {
            position: sticky; top: 0; z-index: 100; background: var(--primary-navy);
            padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; height: 40px;
        }
        .header-left { display: flex; align-items: center; gap: 20px; font-weight: 600; color: #ecf0f5; cursor: pointer; }
        .user-nav { display: flex; gap: 20px; align-items: center; font-size: 14px; color: #ecf0f5; }
        .btn-logout { padding: 8px 18px; background: var(--bg-soft); border: none; border-radius: 10px; font-weight: 600; font-size: 13px; cursor: pointer; }

        /* 메인 레이아웃 (3컬럼 구조) */
        .main-layout { display: grid; grid-template-columns: var(--sidebar-width) 1fr var(--sidebar-width); gap: 30px; padding: 40px; min-height: 800px; }

        /* 사이드바 공통 카드 스타일 */
        .side-card { background: white; padding: 24px; border-radius: 20px; box-shadow: var(--card-shadow); margin-bottom: 25px; }
        .side-card h3 { font-size: 16px; font-weight: 800; margin: 0 0 18px 0; color: var(--primary-navy); display: flex; align-items: center; gap: 10px; }
        .side-card h3::before { content: ''; width: 4px; height: 16px; background: var(--accent-blue); border-radius: 2px; }
        
        .menu-item { font-weight: 700; color: var(--primary-navy); padding: 10px 0; cursor: pointer; }
        .menu-item.active { color: var(--accent-blue); }
        .sub-item { padding: 8px 0 8px 20px; font-size: 14px; color: var(--text-sub); cursor: pointer; transition: 0.2s; }
        .sub-item:hover { color: var(--accent-blue); padding-left: 25px; }

        /* 중앙 콘텐츠 영역 */
        .content-area { display: flex; flex-direction: column; gap: 30px; }
        .logo { font-size: 38px; font-weight: 900; color: var(--primary-navy); letter-spacing: -2px; }

        .content-card {
            background: white; border-radius: 24px; box-shadow: var(--card-shadow); padding: 35px;
            min-height: 600px;
        }

        .board-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 30px; padding-bottom: 15px; border-bottom: 2px solid #f1f5f9;
        }
        .board-title { font-size: 24px; font-weight: 800; color: var(--text-main); }

        .btn-write {
            background: var(--primary-navy); color: white; border: none;
            padding: 12px 25px; border-radius: 12px; font-weight: 700;
            cursor: pointer; transition: var(--transition);
        }
        .btn-write:hover { background: var(--accent-blue); transform: translateY(-2px); }

        /* 테이블 스타일 */
        .qna-table { width: 100%; border-collapse: collapse; }
        .qna-table th { padding: 15px; border-bottom: 2px solid #f1f5f9; color: var(--text-sub); font-size: 14px; text-align: center; }
        .qna-table td { padding: 20px 15px; border-bottom: 1px solid #f1f5f9; text-align: center; font-size: 15px; font-weight: 600; }
        
        .title-td { text-align: left !important; cursor: pointer; transition: 0.2s; }
        .title-td:hover { color: var(--accent-blue); }

        .status-badge {
            padding: 6px 12px; border-radius: 8px; font-size: 12px; font-weight: 800;
        }
        .waiting { background: #fee2e2; color: #ef4444; }
        .completed { background: #dcfce7; color: #22c55e; }

        .lock-icon { margin-right: 8px; color: #94a3b8; }
        .private-text { color: #94a3b8; font-weight: 400; }

        /* 페이지네이션 */
        .pagination { display: flex; justify-content: center; gap: 10px; margin-top: 40px; }
        .page-btn {
            padding: 8px 16px; border: 1px solid #e2e8f0; background: white;
            font-size: 14px; font-weight: 600; cursor: pointer; border-radius: 8px; transition: 0.2s;
        }
        .page-btn.active { background: var(--primary-navy); color: white; border-color: var(--primary-navy); }
        .page-btn:hover:not(.active) { background: #f1f5f9; }

        footer { text-align: center; padding: 40px; color: #94a3b8; font-size: 14px; }
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
        <aside class="side-left">
            <div class="side-card">
                <h3>카테고리</h3>
                <div class="menu-item">갤러리</div>
                <div class="menu-item">커뮤니티</div>
                <div class="sub-item">자유게시판</div>
                <div class="sub-item">공략게시판</div>
                <div class="menu-item active">고객지원</div>
                <div class="sub-item" style="color: var(--accent-blue); font-weight: 700;">1:1 문의</div>
                <div class="sub-item">FAQ</div>
            </div>
        </aside>

        <main class="content-area">
            <div class="logo">LOG.GG</div>
            
            <div class="content-card">
                <div class="board-header">
                    <h2 class="board-title">1:1 문의 내역</h2>
                    <button class="btn-write" onclick="location.href='qna-write.html'">새 문의하기</button>
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