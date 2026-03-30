<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="gameId" value="lol" />
<c:set var="currentGameName" value="리그 오브 레전드" />
<c:set var="headerTitle" value="리그 오브 레전드" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/lol/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/lol/script.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>

<title>${champ.champName} - 롤 챔피언 상세 정보</title>
</head>
<body>
    <%-- 공통 헤더 포함 --%>
    <%@ include file="../common/header.jsp"%>

    <div class="main-layout">
        <aside class="side-left">
            <%-- ✨ 이제 여기서 게시판을 눌러도 /board/free_lol로 잘 연결됩니다! ✨ --%>
            <%@ include file="../common/sidebar.jsp" %>
        </aside>

        <main class="content-area">
            <div class="top-row">
                <a href="<c:url value='/lol/main'/>" class="clean-link">
                    <div class="logo">LOG.GG</div>
                </a>
            </div>

            <div class="detail-card">
                <div class="hero-title">
                    <c:out value="${champ.champName}" />
                </div>

                <div class="hero-info-top">
                    <div class="hero-illust">
                        <img src="${champ.champImg}" alt="${champ.champName}">
                    </div>
                    <div class="hero-desc-text">
                        <div class="desc-title">${champ.champName}의 상세 정보입니다.</div>
                        <div class="desc-pos">
                            주요 포지션: <c:out value="${champ.champPosition}" />
                        </div>
                    </div>
                </div>

                <div class="detail-tabs">
                    <a href="#skill" class="clean-link"><div class="d-tab">스킬</div></a> 
                    <a href="#skin" class="clean-link"><div class="d-tab">스킨</div></a> 
                    <a href="#item" class="clean-link"><div class="d-tab">룬 / 아이템</div></a> 
                    <a href="#patch" class="clean-link"><div class="d-tab">패치</div></a>
                </div>

                <div class="info-section" id="skill">
                    <h4>스킬 정보</h4>
                    <div class="skill-list">
                        <%-- 패시브 --%>
                        <div class="skill-item">
                            <img src="${champ.skills.skillPImg}" alt="패시브" class="skill-icon">
                            <div>
                                <div class="skill-name">P (패시브) - ${champ.skills.skillPName}</div>
                                <div class="skill-desc">${champ.skills.skillPDesc}</div>
                            </div>
                        </div>
                        <%-- Q 스킬 --%>
                        <div class="skill-item">
                            <img src="${champ.skills.skillQImg}" alt="Q" class="skill-icon">
                            <div>
                                <div class="skill-name">Q - ${champ.skills.skillQName}</div>
                                <div class="skill-desc">${champ.skills.skillQDesc}</div>
                            </div>
                        </div>
                        <%-- W 스킬 --%>
                        <div class="skill-item">
                            <img src="${champ.skills.skillWImg}" alt="W" class="skill-icon">
                            <div>
                                <div class="skill-name">W - ${champ.skills.skillWName}</div>
                                <div class="skill-desc">${champ.skills.skillWDesc}</div>
                            </div>
                        </div>
                        <%-- E 스킬 --%>
                        <div class="skill-item">
                            <img src="${champ.skills.skillEImg}" alt="E" class="skill-icon">
                            <div>
                                <div class="skill-name">E - ${champ.skills.skillEName}</div>
                                <div class="skill-desc">${champ.skills.skillEDesc}</div>
                            </div>
                        </div>
                        <%-- R 스킬 --%>
                        <div class="skill-item">
                            <img src="${champ.skills.skillRImg}" alt="R" class="skill-icon ultimate">
                            <div>
                                <div class="skill-name ultimate">R (궁극기) - ${champ.skills.skillRName}</div>
                                <div class="skill-desc">${champ.skills.skillRDesc}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="info-section" id="skin">
                    <h4>스킨 목록</h4>
                    <div class="skin-list">
                        <c:choose>
                            <c:when test="${not empty champ.skins}">
                                <c:forEach var="skin" items="${champ.skins}">
                                    <div class="skin-box">
                                        <img src="${skin.champSkinImg}" alt="${skin.champSkinName}">
                                        <div class="skin-box-name">
                                            <c:out value="${skin.champSkinName}" />
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state skin">등록된 스킨 정보가 없습니다.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="info-section" id="item">
                    <h4>추천 룬 / 아이템</h4>
                    <div class="empty-state">분석된 통계 데이터를 바탕으로 곧 업데이트될 예정입니다.</div>
                </div>

                <div class="info-section" id="patch">
                    <h4>최근 패치 내역</h4>
                    <div class="empty-state">해당 챔피언은 최근 패치에서 변경 사항이 없습니다.</div>
                </div>

                <div class="comment-row">
                    <div>댓글 글쓴이 |</div>
                    <div class="comment-main">댓글 내용</div>
                    <div class="comment-side">
                        <span>| 댓글신고 |</span> <span>공감</span>
                    </div>
                </div>
            </div>
        </main>

        <aside class="side-right">
            <div class="side-card">
                <h3>챔피언 팁</h3>
                <div class="side-card-desc">
                    상대 라이너와의 상성을 확인하고 룬 세팅을 변경해보세요.
                </div>
            </div>
            
            <div class="side-card">
                <h3>최근 업데이트</h3>
                <div class="side-card-desc">
                    최신 업데이트 내용을 확인하세요.
                </div>
            </div>
        </aside>
    </div>

    <%-- 공통 푸터 포함 --%>
    <%@ include file="../common/footer.jsp"%>
</body>
</html>