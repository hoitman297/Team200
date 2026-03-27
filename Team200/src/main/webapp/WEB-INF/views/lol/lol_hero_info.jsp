<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%-- 💖 [핵심 수정] 사이드바와 헤더 경로를 'lol'로 고정하는 변수 선언 💖 --%>
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
				<a href="<c:url value='/lol/main'/>" style="text-decoration: none;">
					<div class="logo">LOG.GG</div>
				</a>
			</div>

			<div class="detail-card">
				<div class="hero-title">
					<c:out value="${champ.champName}" />
					<span style="font-size: 14px; color: #64748b; font-weight: normal; margin-left: 10px;">
						<c:out value="${champ.champPosition}" />
					</span>
				</div>

				<div class="hero-info-top">
					<div class="hero-illust" style="border-radius: 12px; overflow: hidden; border: 1px solid #e2e8f0;">
						<img src="${champ.champImg}" alt="${champ.champName}" style="width: 100%; height: 100%; object-fit: cover;">
					</div>
					<div class="hero-desc-text">
						<div style="font-weight: 600; font-size: 16px;">${champ.champName}의 상세 정보입니다.</div>
						<div style="color: #3b82f6; margin-top: 5px; font-weight: 500;">
							주요 포지션: <c:out value="${champ.champPosition}" />
						</div>
						<div style="margin-top: 5px; color: #64748b; font-size: 14px;">난이도: 데이터 준비 중 / 공격 타입: 데이터 준비 중</div>
					</div>
				</div>

				<div class="detail-tabs">
					<div class="d-tab active">스킬</div>
					<a href="#skin" style="text-decoration: none; color: inherit;"><div class="d-tab">스킨</div></a> 
					<a href="#item" style="text-decoration: none; color: inherit;"><div class="d-tab">룬 / 아이템</div></a> 
					<a href="#patch" style="text-decoration: none; color: inherit;"><div class="d-tab">패치</div></a>
				</div>

				<div class="info-section" id="skill">
					<h4>스킬 정보</h4>
					<div class="skill-list" style="display: flex; flex-direction: column; gap: 20px;">
						<%-- 패시브 --%>
						<div class="skill-item" style="display: flex; align-items: flex-start; gap: 15px;">
							<img src="${champ.skills.skillPImg}" alt="패시브" style="width: 50px; height: 50px; border-radius: 8px; background: #000;">
							<div>
								<div style="font-weight: bold;">P (패시브) - ${champ.skills.skillPName}</div>
								<div style="font-size: 14px; color: #64748b; margin-top: 5px; line-height: 1.5;">${champ.skills.skillPDesc}</div>
							</div>
						</div>
						<%-- Q 스킬 --%>
						<div class="skill-item" style="display: flex; align-items: flex-start; gap: 15px;">
							<img src="${champ.skills.skillQImg}" alt="Q" style="width: 50px; height: 50px; border-radius: 8px; background: #000;">
							<div>
								<div style="font-weight: bold;">Q - ${champ.skills.skillQName}</div>
								<div style="font-size: 14px; color: #64748b; margin-top: 5px; line-height: 1.5;">${champ.skills.skillQDesc}</div>
							</div>
						</div>
						<%-- W 스킬 --%>
						<div class="skill-item" style="display: flex; align-items: flex-start; gap: 15px;">
							<img src="${champ.skills.skillWImg}" alt="W" style="width: 50px; height: 50px; border-radius: 8px; background: #000;">
							<div>
								<div style="font-weight: bold;">W - ${champ.skills.skillWName}</div>
								<div style="font-size: 14px; color: #64748b; margin-top: 5px; line-height: 1.5;">${champ.skills.skillWDesc}</div>
							</div>
						</div>
						<%-- E 스킬 --%>
						<div class="skill-item" style="display: flex; align-items: flex-start; gap: 15px;">
							<img src="${champ.skills.skillEImg}" alt="E" style="width: 50px; height: 50px; border-radius: 8px; background: #000;">
							<div>
								<div style="font-weight: bold;">E - ${champ.skills.skillEName}</div>
								<div style="font-size: 14px; color: #64748b; margin-top: 5px; line-height: 1.5;">${champ.skills.skillEDesc}</div>
							</div>
						</div>
						<%-- R 스킬 --%>
						<div class="skill-item" style="display: flex; align-items: flex-start; gap: 15px;">
							<img src="${champ.skills.skillRImg}" alt="R" style="width: 50px; height: 50px; border-radius: 8px; border: 2px solid #eab308; background: #000;">
							<div>
								<div style="font-weight: bold; color: #ca8a04;">R (궁극기) - ${champ.skills.skillRName}</div>
								<div style="font-size: 14px; color: #64748b; margin-top: 5px; line-height: 1.5;">${champ.skills.skillRDesc}</div>
							</div>
						</div>
					</div>
				</div>

				<div class="info-section" id="skin">
					<h4>스킨 목록</h4>
					<div class="skin-list" style="display: flex; flex-wrap: wrap; gap: 20px;">
						<c:choose>
							<c:when test="${not empty champ.skins}">
								<c:forEach var="skin" items="${champ.skins}">
									<div class="skin-box" style="width: 200px; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); border: 1px solid #f1f5f9;">
										<img src="${skin.champSkinImg}" alt="${skin.champSkinName}" style="width: 100%; height: 120px; object-fit: cover; display: block;">
										<div style="padding: 12px; background: #fff; text-align: center; font-weight: 600; font-size: 13px; color: #334155;">
											<c:out value="${skin.champSkinName}" />
										</div>
									</div>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<div style="font-size: 14px; color: #94a3b8; width: 100%; padding: 20px;">등록된 스킨 정보가 없습니다.</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

				<div class="info-section" id="item">
					<h4>추천 룬 / 아이템</h4>
					<div style="font-size: 14px; color: #94a3b8; padding: 10px;">분석된 통계 데이터를 바탕으로 곧 업데이트될 예정입니다.</div>
				</div>

				<div class="info-section" id="patch">
					<h4>최근 패치 내역</h4>
					<div style="font-size: 14px; color: #94a3b8; padding: 10px;">해당 챔피언은 최근 패치에서 변경 사항이 없습니다.</div>
				</div>

				<div class="comment-row" style="margin-top: 30px; border-top: 1px solid #e2e8f0; padding-top: 20px;">
					<div style="font-weight: 600; color: #1e293b;">실버탈출기원 |</div>
					<div class="comment-main" style="flex: 1; padding-left: 10px; color: #475569;">스킨 너무 예쁘네요! 당장 사러 갑니다.</div>
					<div class="comment-side" style="font-size: 12px; color: #94a3b8;">
						<span style="cursor: pointer;">| 신고 |</span> 
						<span style="cursor: pointer; color: #3b82f6; margin-left: 5px;">공감</span>
					</div>
				</div>
			</div>
		</main>

		<aside class="side-right">
			<div class="side-card" style="background: #cbd5e1; height: 300px; border-radius: 12px; padding: 20px;">
				<h3 style="margin-bottom: 15px;">챔피언 팁</h3>
				<div style="font-size: 14px; color: #475569; line-height: 1.8;">
					상대 라이너와의 상성을 확인하고 룬 세팅을 변경해보세요.
				</div>
			</div>
		</aside>
	</div>

	<%-- 공통 푸터 포함 --%>
	<%@ include file="../common/footer.jsp"%>
</body>
</html>