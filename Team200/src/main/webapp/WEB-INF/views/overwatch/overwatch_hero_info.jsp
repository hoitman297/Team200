<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="gameId" value="overwatch" />
<c:set var="currentGameName" value="오버워치" />
<c:set var="headerTitle" value="오버워치" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/overwatch/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/overwatch/script.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
<title>${hero.heroName} - 오버워치 영웅 정보</title>
</head>
<body>
    <%@ include file="../common/header.jsp"%>

    <div class="main-layout">
        <aside class="side-left">
            <%@ include file="../common/sidebar.jsp"%>
        </aside>

        <main class="content-area">
            <div class="top-row">
                <a href="<c:url value ='/ow/main'/>" class="clean-link">
                    <div class="logo">LOG.GG</div>
                </a>
            </div>
            
            <div class="detail-card">
                <div class="hero-title">${hero.heroName} / ${hero.heroPosition}</div>
                <div class="hero-info-top">
                    <div class="hero-illust">
                        <img src="${hero.heroImg}" alt="${hero.heroName}">
                    </div>

                    <div class="hero-desc-text">
                        <div class="desc-title">${hero.heroName}</div>
                        <div class="desc-intro">${hero.heroIntro}</div>
                        <div class="desc-pos">
                            포지션: <span>${hero.heroPosition}</span>
                        </div>
                        <div class="desc-hp">최대 HP: ${hero.heroHp}</div>
                    </div>
                </div>

                <div class="detail-tabs">
                    <a href="#skill" class="clean-link"><div class="d-tab">스킬</div></a> 
                    <a href="#skin" class="clean-link"><div class="d-tab">스킨</div></a>
                    <a href="#patch" class="clean-link"><div class="d-tab">패치</div></a>
                </div>

                <div class="info-section" id="skill">
                    <h4>스킬 목록</h4>
                    <div class="skill-list">
                        
                        <%-- 좌클릭 --%>
                        <c:if test="${not empty skills.skillLclickName}">
                            <div class="skill-item">
                                <img src="${skills.skillLclickImg}" alt="좌클릭" class="skill-icon">
                                <div>
                                    <div class="skill-name">${skills.skillLclickName}</div>
                                    <div class="skill-desc">${skills.skillLclickDesc}</div>
                                </div>
                            </div>
                        </c:if>

                        <%-- 우클릭 --%>
                        <c:if test="${not empty skills.skillRclickName}">
                            <div class="skill-item">
                                <img src="${skills.skillRclickImg}" alt="우클릭" class="skill-icon">
                                <div>
                                    <div class="skill-name">${skills.skillRclickName}</div>
                                    <div class="skill-desc">${skills.skillRclickDesc}</div>
                                </div>
                            </div>
                        </c:if>

                        <%-- Shift 스킬 --%>
                        <c:if test="${not empty skills.skillShiftName}">
                            <div class="skill-item">
                                <img src="${skills.skillShiftImg}" alt="Shift" class="skill-icon">
                                <div>
                                    <div class="skill-name">${skills.skillShiftName}</div>
                                    <div class="skill-desc">${skills.skillShiftDesc}</div>
                                </div>
                            </div>
                        </c:if>

                        <%-- E 스킬 --%>
                        <c:if test="${not empty skills.skillEName}">
                            <div class="skill-item">
                                <img src="${skills.skillEImg}" alt="E" class="skill-icon">
                                <div>
                                    <div class="skill-name">${skills.skillEName}</div>
                                    <div class="skill-desc">${skills.skillEDesc}</div>
                                </div>
                            </div>
                        </c:if>

                        <%-- Q 스킬 (궁극기) --%>
                        <c:if test="${not empty skills.skillQName}">
                            <div class="skill-item">
                                <img src="${skills.skillQImg}" alt="Q (궁극기)" class="skill-icon ultimate">
                                <div>
                                    <div class="skill-name ultimate">${skills.skillQName}</div>
                                    <div class="skill-desc">${skills.skillQDesc}</div>
                                </div>
                            </div>
                        </c:if>
                        
                    </div>
                </div>

                <div class="info-section" id="skin">
                    <h4>스킨 목록</h4>
                    <div class="skin-list">
                        <c:choose>
                            <c:when test="${not empty skinList}">
                                <c:forEach var="skin" items="${skinList}">
                                    <div class="skin-box">
                                        <img src="${skin.heroSkinImg}" alt="${skin.heroSkinName}">
                                        <div class="skin-name">
                                            <c:out value="${skin.heroSkinName}" />
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state skin">등록된 스킨이 없습니다.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="info-section" id="patch">
                    <h4>패치 내역</h4>
                    <div class="empty-state">최근 패치 내역이 없습니다.</div>
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
            <%-- 인라인 스타일 제거 --%>
            <div class="side-card">
                <h3>최근 업데이트</h3>
                <div class="side-card-desc">
                    최신 업데이트 내용을 확인하세요.
                </div>
            </div>
        </aside>
    </div>

    <%@ include file="../common/footer.jsp"%>

</body>
</html>