<<<<<<< HEAD
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
=======
<%@ page session="false" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
>>>>>>> main

<%-- 💖 [핵심 수정] 모든 공통 컴포넌트(사이드바, 헤더)를 위한 변수 선언 💖 --%>
<c:set var="gameId" value="overwatch" />
<c:set var="currentGameName" value="오버워치" />
<c:set var="headerTitle" value="오버워치" />

<!DOCTYPE html>
<html lang="ko">
<head>
<<<<<<< HEAD
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
    <%-- 공통 헤더 포함 --%>
    <%@ include file="../common/header.jsp" %>
    
    <div class="main-layout">
        <aside class="side-left">
             <%@ include file="../common/sidebar.jsp" %>
        </aside>

        <main class="content-area">
            <div class="top-row">
                <a href="<c:url value ='/overwatch/main'/>" style="text-decoration: none;">
                    <div class="logo">LOG.GG</div>
                </a>
     
            </div>
            
            <div class="detail-card">
                <div class="hero-title">${hero.heroName} / ${hero.heroPosition}</div>

                <div class="hero-info-top">
                    <div class="hero-illust" style="padding: 0; border: none; overflow: hidden;">
                        <img src="${hero.heroImg}" alt="${hero.heroName}" style="width: 100%; height: 100%; object-fit: cover;">
                    </div>
                    
                    <div class="hero-desc-text">
                        <div style="color: var(--primary-navy); font-weight: 800; font-size: 18px;">${hero.heroName}</div>
                        <div style="font-weight: 500; color: #475569; line-height: 1.5; margin-top: 5px;">${hero.heroIntro}</div>
                        <div style="margin-top: 10px;">포지션: <span style="color: var(--accent-blue); font-weight: 600;">${hero.heroPosition}</span></div>
                        <div style="font-weight: 500;">최대 HP: <span style="color: #ef4444;">${hero.heroHp}</span></div>
                    </div>
                </div>
=======
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/overwatch/style.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/main/style.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/overwatch/script.js"
	defer></script>
<script
	src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
<title>${hero.heroName}-오버워치</title>
</head>
<body>
	<c:set var="headerTitle" value="오버워치" />
	<%@ include file="../common/header.jsp"%>

	<div class="main-layout">
		<aside class="side-left">
			<%@ include file="../common/sidebar.jsp"%>
		</aside>

		<main class="content-area">
			<div class="top-row">
				<a href="<c:url value ='/ow/main'/>"><div class="logo">LOG.GG</div></a>
				<div class="search-bar">
					<input type="text" placeholder="영웅 검색"> <span>🔍</span>
				</div>
			</div>
>>>>>>> main

			<div class="detail-card">
				<div class="hero-title">${hero.heroName}/${hero.heroPosition}</div>

<<<<<<< HEAD
                <div class="info-section" id="skill">
                    <h4>스킬 목록</h4>
                    <div class="skill-list">
                        <c:if test="${not empty skills.skillLclickName}">
                            <div class="skill-item">
                                <img src="${skills.skillLclickImg}" style="width:35px; height:35px; background:#000; border-radius:4px;" alt="L-Click">
                                <strong>L-CLICK</strong> - ${skills.skillLclickName} 
                                <span style="font-size: 13px; color: #64748b; font-weight: 500; margin-left: 5px;">: ${skills.skillLclickDesc}</span>
                            </div>
                        </c:if>

                        <c:if test="${not empty skills.skillRclickName}">
                            <div class="skill-item">
                                <img src="${skills.skillRclickImg}" style="width:35px; height:35px; background:#000; border-radius:4px;" alt="R-Click">
                                <strong>R-CLICK</strong> - ${skills.skillRclickName}
                                <span style="font-size: 13px; color: #64748b; font-weight: 500; margin-left: 5px;">: ${skills.skillRclickDesc}</span>
                            </div>
                        </c:if>

                        <c:if test="${not empty skills.skillShiftName}">
                            <div class="skill-item">
                                <img src="${skills.skillShiftImg}" style="width:35px; height:35px; background:#000; border-radius:4px;" alt="Shift">
                                <strong>SHIFT</strong> - ${skills.skillShiftName}
                                <span style="font-size: 13px; color: #64748b; font-weight: 500; margin-left: 5px;">: ${skills.skillShiftDesc}</span>
                            </div>
                        </c:if>

                        <c:if test="${not empty skills.skillEName}">
                            <div class="skill-item">
                                <img src="${skills.skillEImg}" style="width:35px; height:35px; background:#000; border-radius:4px;" alt="E">
                                <strong>E</strong> - ${skills.skillEName}
                                <span style="font-size: 13px; color: #64748b; font-weight: 500; margin-left: 5px;">: ${skills.skillEDesc}</span>
                            </div>
                        </c:if>

                        <c:if test="${not empty skills.skillQName}">
                            <div class="skill-item">
                                <img src="${skills.skillQImg}" style="width:35px; height:35px; background:#000; border-radius:4px; border:2px solid #eab308;" alt="Ultimate">
                                <strong style="color: #ca8a04;">Q (궁극기)</strong> - ${skills.skillQName}
                                <span style="font-size: 13px; color: #64748b; font-weight: 500; margin-left: 5px;">: ${skills.skillQDesc}</span>
                            </div>
                        </c:if>
                    </div>
                </div>

                <div class="info-section" id="skin">
                    <h4>스킨 목록</h4>
                    <div class="skin-list">
                        <div class="skin-box" style="background: #f1f5f9; border: 1px dashed #cbd5e1; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #94a3b8;">이미지 준비중</div>
                        <div class="skin-box" style="background: #f1f5f9; border: 1px dashed #cbd5e1; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #94a3b8;">이미지 준비중</div>
                        <div class="skin-box" style="background: #f1f5f9; border: 1px dashed #cbd5e1; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #94a3b8;">이미지 준비중</div>
                    </div>
                </div>

                <div class="info-section" id="sp">
                    <h4>특전 목록</h4>
                    <div style="font-size: 14px; color: #94a3b8;">해당 영웅의 특전 정보가 등록되지 않았습니다.</div>
                </div>

                <div class="info-section" id="patch">
                    <h4>패치 내역</h4>
                    <div style="font-size: 14px; color: #94a3b8;">최근 6개월간의 패치 내역이 없습니다.</div>
                </div>

                <div class="comment-row" style="margin-top: 30px; border-top: 1px solid #e2e8f0; padding-top: 15px;">
                    <div style="font-weight: 600;">댓글 작성자 |</div>
                    <div class="comment-main" style="flex: 1; padding-left: 10px; color: #475569;">영웅에 대한 의견을 남겨주세요.</div>
                    <div class="comment-side" style="font-size: 12px; color: #94a3b8;">
                        <span style="cursor:pointer;">| 댓글신고 |</span>
                        <span style="cursor:pointer; color: var(--accent-blue); margin-left: 5px;">공감</span>
                    </div>
                </div>
            </div>
        </main>

        <aside class="side-right">
            <div class="side-card" style="background: #cbd5e1; height: 300px; padding: 15px; border-radius: 12px;">
                <h3 style="margin-bottom: 15px;">최근 업데이트</h3>
                <div style="font-size: 14px; color: #475569; line-height: 1.8;">
                    오버워치2 신규 시즌 패치 노트가 업로드되었습니다. 지금 바로 확인해보세요!
                </div>
            </div>
        </aside>
    </div>
    
    <%-- 공통 푸터 포함 --%>
    <%@ include file="../common/footer.jsp" %>
=======
				<div class="hero-info-top">
					<div class="hero-illust"
						style="padding: 0; border: none; overflow: hidden;">
						<img src="${hero.heroImg}" alt="${hero.heroName}"
							style="width: 100%; height: 100%; object-fit: cover;">
					</div>

					<div class="hero-desc-text">
						<div
							style="color: var(- -primary-navy); font-weight: 800; font-size: 18px;">${hero.heroName}</div>
						<div style="font-weight: 500; color: #475569; line-height: 1.5;">${hero.heroIntro}</div>
						<div style="margin-top: 10px;">
							포지션: <span style="color: var(- -accent-blue);">${hero.heroPosition}</span>
						</div>
						<div>최대 HP: ${hero.heroHp}</div>
					</div>
				</div>

				<div class="detail-tabs">
					<a href="#skill"><div class="d-tab active">스킬</div></a> <a
						href="#skin"><div class="d-tab">스킨</div></a> <a href="#sp"><div
							class="d-tab">특전</div></a> <a href="#patch"><div class="d-tab">패치</div></a>
				</div>

				<div class="info-section" id="skill">
					<h4>스킬 목록</h4>
					<div class="skill-list">
						<c:if test="${not empty skills.skillLclickName}">
							<div class="skill-item">
								<img src="${skills.skillLclickImg}"
									style="width: 30px; height: 30px; background: #000; border-radius: 4px;">
								${skills.skillLclickName} <span
									style="font-size: 13px; color: #64748b; font-weight: 500; margin-left: 5px;">:
									${skills.skillLclickDesc}</span>
							</div>
						</c:if>

						<c:if test="${not empty skills.skillRclickName}">
							<div class="skill-item">
								<img src="${skills.skillRclickImg}"
									style="width: 30px; height: 30px; background: #000; border-radius: 4px;">
								${skills.skillRclickName} <span
									style="font-size: 13px; color: #64748b; font-weight: 500; margin-left: 5px;">:
									${skills.skillRclickDesc}</span>
							</div>
						</c:if>

						<c:if test="${not empty skills.skillShiftName}">
							<div class="skill-item">
								<img src="${skills.skillShiftImg}"
									style="width: 30px; height: 30px; background: #000; border-radius: 4px;">
								${skills.skillShiftName} <span
									style="font-size: 13px; color: #64748b; font-weight: 500; margin-left: 5px;">:
									${skills.skillShiftDesc}</span>
							</div>
						</c:if>

						<c:if test="${not empty skills.skillEName}">
							<div class="skill-item">
								<img src="${skills.skillEImg}"
									style="width: 30px; height: 30px; background: #000; border-radius: 4px;">
								${skills.skillEName} <span
									style="font-size: 13px; color: #64748b; font-weight: 500; margin-left: 5px;">:
									${skills.skillEDesc}</span>
							</div>
						</c:if>

						<c:if test="${not empty skills.skillQName}">
							<div class="skill-item">
								<img src="${skills.skillQImg}"
									style="width: 30px; height: 30px; background: #000; border-radius: 4px;">
								${skills.skillQName} <span
									style="font-size: 13px; color: #64748b; font-weight: 500; margin-left: 5px;">:
									${skills.skillQDesc}</span>
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
								<div style="font-size: 14px; color: #94a3b8; padding: 10px 0;">등록된
									스킨이 없습니다.</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

				<div class="info-section" id="sp">
					<h4>특전 목록</h4>
					<div style="font-size: 14px; color: #94a3b8;">내용이 없습니다.</div>
				</div>

				<div class="info-section" id="patch">
					<h4>패치 내역</h4>
					<div style="font-size: 14px; color: #94a3b8;">최근 패치 내역이 없습니다.</div>
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
			<div class="side-card" style="background: #cbd5e1; height: 300px;">
				<h3>최근 업데이트</h3>
				<div style="font-size: 14px; color: #475569; line-height: 1.8;">
					최신 업데이트 내용을 확인하세요.</div>
			</div>
		</aside>
	</div>

	<%@ include file="../common/footer.jsp"%>
>>>>>>> main

</body>
</html>