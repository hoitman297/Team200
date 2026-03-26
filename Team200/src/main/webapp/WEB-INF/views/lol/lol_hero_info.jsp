<%@ page session="false" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="gameId" value="lol" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/lol/style.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/main/style.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/lol/script.js"
	defer></script>
<script
	src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
<title>${champ.champName}- 롤 상세</title>
</head>
<body>
	<c:set var="headerTitle" value="리그 오브 레전드" />
	<%@ include file="../common/header.jsp"%>

	<div class="main-layout">
		<aside class="side-left">
            <%@ include file="../common/sidebar.jsp" %>
        </aside>

		<main class="content-area">
			<div class="top-row">
				<a href="<c:url value='/lol/main'/>"><div class="logo">LOG.GG</div></a>
				<div class="search-bar">
					<input type="text" placeholder="챔피언 검색"> <span>🔍</span>
				</div>
			</div>

			<div class="detail-card">
				<div class="hero-title">
					<c:out value="${champ.champName}" />
					<span
						style="font-size: 14px; color: #64748b; font-weight: normal; margin-left: 10px;">
							<c:out value="${champ.champPosition}" />
					</span>
				</div>

				<div class="hero-info-top">
					<div class="hero-illust">
						<img src="${champ.champImg}" alt="${champ.champName}"
							style="width: 100%; height: 100%; object-fit: cover;">
					</div>
					<div class="hero-desc-text">
						<div>${champ.champName}의상세 정보입니다.</div>
						<div style="color: #3b82f6;">
							주요 포지션:
							<c:out value="${champ.champPosition}" />
						</div>
						<div>난이도: 데이터 준비 중 / 공격 타입: 데이터 준비 중</div>
					</div>
				</div>
				<div class="detail-tabs">
					<div class="d-tab active">스킬</div>
					<a href="#skin" style="text-decoration: none; color: inherit;"><div
							class="d-tab">스킨</div></a> <a href="#item"
						style="text-decoration: none; color: inherit;"><div
							class="d-tab">룬 / 아이템</div></a> <a href="#patch"
						style="text-decoration: none; color: inherit;"><div
							class="d-tab">패치</div></a>
				</div>

				<div class="info-section" id="skill">
					<h4>스킬 정보</h4>
					<div class="skill-list" style="display: flex; flex-direction: column; gap: 15px;">
						
						<div class="skill-item" style="display: flex; align-items: flex-start; gap: 15px;">
							<img src="${champ.skills.skillPImg}" alt="패시브" style="width: 50px; height: 50px; border-radius: 8px;">
							<div>
								<div style="font-weight: bold;">P (패시브) - ${champ.skills.skillPName}</div>
								<div style="font-size: 14px; color: #64748b; margin-top: 5px; line-height: 1.4;">
									${champ.skills.skillPDesc}
								</div>
							</div>
						</div>

						<div class="skill-item" style="display: flex; align-items: flex-start; gap: 15px;">
							<img src="${champ.skills.skillQImg}" alt="Q" style="width: 50px; height: 50px; border-radius: 8px;">
							<div>
								<div style="font-weight: bold;">Q - ${champ.skills.skillQName}</div>
								<div style="font-size: 14px; color: #64748b; margin-top: 5px; line-height: 1.4;">
									${champ.skills.skillQDesc}
								</div>
							</div>
						</div>

						<div class="skill-item" style="display: flex; align-items: flex-start; gap: 15px;">
							<img src="${champ.skills.skillWImg}" alt="W" style="width: 50px; height: 50px; border-radius: 8px;">
							<div>
								<div style="font-weight: bold;">W - ${champ.skills.skillWName}</div>
								<div style="font-size: 14px; color: #64748b; margin-top: 5px; line-height: 1.4;">
									${champ.skills.skillWDesc}
								</div>
							</div>
						</div>

						<div class="skill-item" style="display: flex; align-items: flex-start; gap: 15px;">
							<img src="${champ.skills.skillEImg}" alt="E" style="width: 50px; height: 50px; border-radius: 8px;">
							<div>
								<div style="font-weight: bold;">E - ${champ.skills.skillEName}</div>
								<div style="font-size: 14px; color: #64748b; margin-top: 5px; line-height: 1.4;">
									${champ.skills.skillEDesc}
								</div>
							</div>
						</div>

						<div class="skill-item" style="display: flex; align-items: flex-start; gap: 15px;">
							<img src="${champ.skills.skillRImg}" alt="R" style="width: 50px; height: 50px; border-radius: 8px;">
							<div>
								<div style="font-weight: bold;">R (궁극기) - ${champ.skills.skillRName}</div>
								<div style="font-size: 14px; color: #64748b; margin-top: 5px; line-height: 1.4;">
									${champ.skills.skillRDesc}
								</div>
							</div>
						</div>

					</div>
				</div>

				<div class="info-section" id="skin">
					<h4>스킨 목록</h4>
					<div class="skin-list" style="display: flex; flex-wrap: wrap; gap: 20px;">
						
						<c:if test="${not empty champ.skins}">
							<c:forEach var="skin" items="${champ.skins}">
								<div class="skin-box" style="width: 250px; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
									<img src="${skin.champSkinImg}" alt="${skin.champSkinName}" style="width: 100%; height: auto; display: block;">
									<div style="padding: 10px; background: #f8fafc; text-align: center; font-weight: bold; font-size: 14px; color: #334155;">
										<c:out value="${skin.champSkinName}" />
									</div>
								</div>
							</c:forEach>
						</c:if>
						
						<c:if test="${empty champ.skins}">
							<div style="font-size: 14px; color: #94a3b8; width: 100%;">등록된 스킨 정보가 없습니다.</div>
						</c:if>

					</div>
				</div>

				<div class="info-section" id="item">
					<h4>추천 룬 / 아이템</h4>
					<div style="font-size: 14px; color: #94a3b8;">준비 중인 데이터입니다.</div>
				</div>

				<div class="info-section" id="patch">
					<h4>최근 패치 내역</h4>
					<div style="font-size: 14px; color: #94a3b8;">해당 챔피언의 최근 변경
						사항이 없습니다.</div>
				</div>

				<div class="comment-row">
					<div>심해 탈출러 |</div>
					<div class="comment-main">이 챔피언 이번 패치로 엄청 상향된 것 같아요!</div>
					<div class="comment-side">
						<span style="cursor: pointer;">| 신고 |</span> <span
							style="cursor: pointer; color: var(- -accent-blue);">공감</span>
					</div>
				</div>
			</div>
		</main>

		<aside class="side-right">
            <div class="side-card" style="background: #cbd5e1; height: 300px;">
                	<h3>최근 업데이트</h3>
            	<div style="font-size: 14px; color: #475569; line-height: 1.8;">
                	최신 업데이트 내용을 확인하세요.
            	</div>
            </div>
        </aside>
	</div>

	<%@ include file="../common/footer.jsp"%>
</body>
</html>