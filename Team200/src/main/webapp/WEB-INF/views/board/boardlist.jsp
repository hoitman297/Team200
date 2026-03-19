<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LOG.GG - 게시판 검색</title>
    <style>
        /* [공통 스타일: 기존 코드 유지] */
        @import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css');
        :root {
            --primary-navy: #475569;
            --accent-blue: #3b82f6;
            --bg-soft: #f8fafc;
            --card-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            --container-width: 1440px;
            --sidebar-width: 280px;
        }

        body {
            margin: 0; padding: 0;
            font-family: 'Pretendard', sans-serif;
            background-color: var(--bg-soft);
            width: var(--container-width);
            margin: 0 auto;
        }

        header {
            position: sticky; top: 0; z-index: 100;
            background: var(--primary-navy);
            padding: 15px 40px;
            display: flex; justify-content: space-between; align-items: center;
            height: 40px;
        }

        .header-left { color: #ecf0f5; font-weight: 600; cursor: pointer; }
        .user-nav { display: flex; gap: 20px; align-items: center; font-size: 14px; color: #ecf0f5; }
        .btn-logout { padding: 8px 18px; background: var(--bg-soft); border: none; border-radius: 10px; font-weight: 600; cursor: pointer; }

        .main-layout {
            display: grid;
            grid-template-columns: var(--sidebar-width) 1fr var(--sidebar-width);
            gap: 30px; padding: 40px;
        }

        /* [사이드바] */
        .side-card { background: white; padding: 24px; border-radius: 20px; box-shadow: var(--card-shadow); margin-bottom: 25px; }
        .side-card h3 { font-size: 16px; font-weight: 800; margin: 0 0 18px 0; color: var(--primary-navy); display: flex; align-items: center; gap: 10px; }
        .side-card h3::before { content: ''; width: 4px; height: 16px; background: var(--accent-blue); border-radius: 2px; }
        .menu-item { font-weight: 700; color: var(--primary-navy); padding: 10px 0; cursor: pointer; }
        .sub-item { padding: 8px 0 8px 20px; font-size: 14px; color: #64748b; cursor: pointer; }
        .sub-item.active { color: var(--accent-blue); font-weight: 700; }

        /* [게시판 및 검색바 영역] */
        .content-area { display: flex; flex-direction: column; gap: 20px; }
        
        /* 로고와 검색바가 나란히 있는 상단 행 */
        .board-top-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .logo { font-size: 32px; font-weight: 900; color: var(--primary-navy); letter-spacing: -1.5px; }

        .search-bar {
            background: white;
            border-radius: 15px;
            padding: 10px 20px;
            width: 320px;
            display: flex;
            align-items: center;
            box-shadow: var(--card-shadow);
            border: 1px solid #e2e8f0;
            transition: var(--transition);
        }

        .search-bar:focus-within { border-color: var(--accent-blue); }
        .search-bar input { border: none; outline: none; width: 100%; font-size: 14px; }

        /* 제목과 글쓰기 버튼 영역 */
        .board-header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            padding: 0 5px;
        }
        .board-title { font-size: 24px; font-weight: 800; color: var(--primary-navy); }
        
        .btn-write {
            padding: 9px 22px;
            background: #e2e8f0;
            color: #475569;
            border: none;
            border-radius: 20px;
            font-weight: 700;
            cursor: pointer;
            transition: var(--transition);
        }
        .btn-write:hover { background: var(--accent-blue); color: white; }

        /* [테이블 및 페이징] */
        .list-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: var(--card-shadow);
        }
        .list-table th { background: #f1f5f9; padding: 15px; font-size: 14px; color: var(--primary-navy); border-bottom: 2px solid #e2e8f0; }
        .list-table td { padding: 16px 15px; text-align: center; border-bottom: 1px solid #f1f5f9; font-size: 14px; }
        .td-title { text-align: left !important; font-weight: 600; }
        .list-table tr:hover { background: #f8fafc; cursor: pointer; }

        .pagination { display: flex; justify-content: center; gap: 12px; margin-top: 25px; font-size: 14px; font-weight: 600; color: #64748b; }
        .page-num { cursor: pointer; }
        .page-num.active { color: var(--accent-blue); text-decoration: underline; }

        footer { padding: 40px; text-align: center; font-size: 13px; color: #94a3b8; background: #f1f5f9; margin-top: 50px; }
    </style>
</head>
<body>

    <header>
        <div class="header-left">☰ 배틀그라운드 ▾</div>
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
                <div class="menu-item">게시판</div>
                <div class="sub-item active">자유 게시판</div>
                <div class="sub-item">공략 게시판</div>
                <div class="menu-item">미디어</div>
            </div>
        </aside>

        <main class="content-area">
            <div class="board-top-row">
                <div class="logo">LOG.GG</div>
                <div class="search-bar">
                    <input type="text" placeholder="게시판 내 글 검색">
                    <span style="cursor:pointer">🔍</span>
                </div>
            </div>

            <div class="board-header">
                <div class="board-title">자유 게시판</div>
                <button class="btn-write">글쓰기</button>
            </div>

            <table class="list-table">
                <thead>
                    <tr>
                        <th style="width: 60px;">번호</th>
                        <th>제목</th>
                        <th style="width: 100px;">글쓴이</th>
                        <th style="width: 100px;">날짜</th>
                        <th style="width: 80px;">조회수</th>
                        <th style="width: 60px;">공감</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>003</td>
                        <td class="td-title">오늘 배그 점검 시간 아시는 분 계신가요?</td>
                        <td>배그왕01</td>
                        <td>25-03-09</td>
                        <td>124</td>
                        <td>5</td>
                    </tr>
                    <tr>
                        <td>002</td>
                        <td class="td-title">공략게판에 올린 에란겔 꿀팁 추천 부탁드려요!</td>
                        <td>user02</td>
                        <td>25-02-01</td>
                        <td>1,240</td>
                        <td>88</td>
                    </tr>
                    <tr>
                        <td>001</td>
                        <td class="td-title">안녕하세요! 신규 유저 인사드립니다.</td>
                        <td>user01</td>
                        <td>25-01-24</td>
                        <td>12</td>
                        <td>2</td>
                    </tr>
                </tbody>
            </table>

            <div class="pagination">
                <span>&lt; 이전</span>
                <span class="page-num active">1</span>
                <span class="page-num">2</span>
                <span class="page-num">3</span>
                <span class="page-num">4</span>
                <span class="page-num">5</span>
                <span>다음 &gt;</span>
            </div>
        </main>

        <aside class="sidebar-right" style="background: #cbd5e1; border-radius: 20px; padding: 25px; height: fit-content;">
            <h3 style="font-size: 16px; margin: 0 0 20px 0; font-weight: 800;">알림</h3>
            <div style="font-size: 14px; color: #475569; line-height: 1.8;">
                검색 기능을 통해 이전에 올라온 꿀팁들을 쉽게 찾아보실 수 있습니다.
            </div>
        </aside>
    </div>

    <footer>© 2026 LOG.GG 배틀그라운드 서비스. 모든 권리 보유.</footer>

</body>
</html>