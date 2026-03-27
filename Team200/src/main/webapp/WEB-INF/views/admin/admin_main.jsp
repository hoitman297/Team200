<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/admin/admin_main/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    <script src="${pageContext.request.contextPath}/resources/admin/admin_main/script.js"></script>
	<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
    
    <title>LOG.GG - 통합 게임 플랫폼</title>
    <%@ include file="../common/header.jsp"%>
</head>
<body>

    <div class="container">
        <aside class="main-side">
            <div class="side-card">
                <h3>| 게임별 패치노트 <button class="btn-mini">
                 <a href="<c:url value = '/admin/patchnote'/>">패치노트 등록</a></button></h3>
                <ul class="patch-list">
                    <li><strong>오버워치</strong><span>2026.03.05</span></li>
                    <li><strong>배틀그라운드</strong><span>2026.02.05</span></li>
                    <li><strong>리그 오브 레전드</strong><span>2026.01.15</span></li>
                </ul>
            </div>
        </aside>

        <main class="main-content">
            <div class="brand-search">
                <h1>LOG.GG</h1>
                <div class="search-box">
                    <input type="text" placeholder="관심 있는 글을 검색해보세요.">
                </div>
            </div>

            <div class="content-card">
                <nav class="tab-nav">
                    <button class="tab-btn active" onclick="openTab(event, 'tab-board')">인기 게시글</button>
                    <button class="tab-btn" onclick="openTab(event, 'tab-hero')">영웅 상세정보</button>
                    <button class="tab-btn" onclick="openTab(event, 'tab-wiki')">배그 아이템 도감</button>
                </nav>

                <div id="tab-board" class="tab-pane active">
                    <table class="board-table">
                        <thead>
                            <tr>
                                <th width="70">공감수</th>
                                <th>제목</th>
                                <th width="120">작성자</th>
                                <th width="90">작성일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="v-count">150</td>
                                <td style="font-weight:700;">LOG.GG 커뮤니티 이용 규칙 필독 가이드</td>
                                <td>관리자</td>
                                <td>03.01</td>
                            </tr>
                            <tr>
                                <td class="v-count">84</td>
                                <td>오늘자 오버워치 패치노트 요약본입니다.</td>
                                <td>겐지장인</td>
                                <td>03.05</td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <div style="margin:40px 0 15px 0; display: flex; justify-content: space-between; align-items: flex-end;">
                        <span style="font-weight:900; font-size:18px; color: var(--navy-header);">최신 갤러리</span>
                        <span style="font-size:13px; color: var(--accent-blue); cursor:pointer; font-weight:700;">더보기 +</span>
                    </div>
                    <div class="footer-visual">
                        <div class="visual-box"></div><div class="visual-box"></div>
                        <div class="visual-box"></div><div class="visual-box"></div>
                    </div>
                </div>

                <div id="tab-hero" class="tab-pane">
                    <div style="font-weight:800; font-size:18px; margin-bottom:20px; color: var(--navy-header);">• 영웅 상세 가이드</div>
                    <div class="hero-header">
                        <div class="hero-img">HERO ILLUSTR</div>
                        <div class="hero-meta">
                            <h2>트레이서 (Tracer)</h2>
                            <p><b>HP:</b> 175</p>
                            <p><b>역할군:</b> 공격 (Damage)</p>
                            <p><b>난이도:</b> ★★★</p>
                        </div>
                    </div>
                    <div class="sub-tabs">
                        <div style="background:var(--navy-header); color:white; border-color:var(--navy-header);">스킬</div>
                        <div>스킨</div><div>특전</div><div>카운터</div><div>패치</div><div>통계</div>
                    </div>
                    <div style="font-weight:800; font-size:15px; margin-bottom:15px;">보유 스킬 목록</div>
                    <ul class="skill-list">
                        <li><b>펄스 쌍권총 (L-CLICK)</b> - 빠르게 발사되는 한 쌍의 권총입니다.</li>
                        <li><b>점멸 (SHIFT)</b> - 이동하려는 방향으로 빠르게 공간을 이동합니다.</li>
                        <li><b>시간 역행 (E)</b> - 몇 초 전의 위치와 상태로 되돌아갑니다.</li>
                        <li><b>펄스 폭탄 (R)</b> - 부착 가능한 강력한 폭탄을 던집니다.</li>
                    </ul>
                    <div class="comment-bar">
                        <span><b>배그왕01</b> |</span>
                        <span style="flex:1; padding-left:15px;">트레이서는 역시 점멸 활용이 제일 중요한 것 같아요!</span>
                        <span style="color:var(--text-muted); font-size:12px;">신고 | 공감</span>
                    </div>
                </div>

                <div id="tab-wiki" class="tab-pane">
                    <div class="wiki-layout">
                        <div class="wiki-menu">
                            <div class="wiki-menu-item"><div></div><span>무기</span></div>
                            <div class="wiki-menu-item"><div></div><span>부착물</span></div>
                            <div class="wiki-menu-item"><div></div><span>탄약</span></div>
                            <div class="wiki-menu-item"><div></div><span>방어구</span></div>
                        </div>
                        <div style="flex:1">
                            <table class="wiki-table">
                                <thead>
                                    <tr>
                                        <th>아이콘</th><th>이름</th><th>종류</th><th>데미지</th><th>장탄수</th><th>탄약</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr><td><div class="item-icon"></div></td><td><b>M416</b></td><td>AR</td><td>41</td><td>30</td><td>5.56mm</td></tr>
                                    <tr><td><div class="item-icon"></div></td><td><b>Beryl M762</b></td><td>AR</td><td>44</td><td>30</td><td>7.62mm</td></tr>
                                    <tr><td><div class="item-icon"></div></td><td><b>Kar98k</b></td><td>SR</td><td>79</td><td>5</td><td>7.62mm</td></tr>
                                    <tr><td><div class="item-icon"></div></td><td><b>Vector</b></td><td>SMG</td><td>31</td><td>19</td><td>9mm</td></tr>
                                    <tr><td><div class="item-icon"></div></td><td><b>S12K</b></td><td>SG</td><td>24</td><td>5</td><td>12G</td></tr>
                                </tbody>
                            </table>
                            <div class="pagination">
                                <button>← 이전</button>
                                <button style="background:var(--accent-blue); color:white; border-color:var(--accent-blue);">1</button>
                                <button>2</button>
                                <button>3</button>
                                <button>다음 →</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <aside class="main-side">
            <div class="side-card" style="background:#cbd5e1">
                <h3 style="border-color: #475569;">공지사항 
                <button class="btn-mini" style="background:#fff">
                <a href="<c:url value = '/admin/notice'/>">공지 등록</a></button>
                </h3>
                <ul class="patch-list">
                    <li style="border-color: #94a3b8;">공개 테스트 서버 안내<span>2026.03.10</span></li>
                    <li style="border-color: #94a3b8;">웹사이트 업데이트 내역<span>2026.03.01</span></li>
                </ul>
            </div>
        </aside>
    </div>

    <footer>© 2026 LOG.GG 게임 커뮤니티 플랫폼. 모든 권리 보유.</footer>
</body>
</html>