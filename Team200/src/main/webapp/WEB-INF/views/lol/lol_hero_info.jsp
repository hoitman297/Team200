<%@ page session="false" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="gameId" value="lol" />
<c:set var="currentGameName" value="리그 오브 레전드" />
<c:set var="headerTitle" value="리그 오브 레전드" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
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
<title>${champ.champName}- 롤 챔피언 상세 정보</title>
</head>
<body>
	<%@ include file="../common/header.jsp"%>

	<div class="main-layout">
		<aside class="side-left">
			<%@ include file="../common/sidebar.jsp"%>
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
						<div class="desc-title">${champ.champName}</div>
						<div class="desc-pos">포지션: <span>${champ.champPosition}</span></div>
						<div class="desc-intro">${champ.champIntro}</div>
					</div>
				</div>

				<div class="detail-tabs">
					<a href="#skill" class="clean-link"><div class="d-tab">스킬</div></a>
					<a href="#skin" class="clean-link"><div class="d-tab">스킨</div></a>
					<a href="#item" class="clean-link"><div class="d-tab">룬 /
							아이템</div></a> <a href="#patch" class="clean-link"><div class="d-tab">패치</div></a>
				</div>

				<div class="info-section" id="skill">
					<h4>스킬 정보</h4>
					<div class="skill-list">
						<%-- 패시브 --%>
						<div class="skill-item">
							<img src="${champ.skills.skillPImg}" alt="패시브" class="skill-icon">
							<div>
								<div class="skill-name">P (패시브) -
									${champ.skills.skillPName}</div>
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
							<img src="${champ.skills.skillRImg}" alt="R"
								class="skill-icon ultimate">
							<div>
								<div class="skill-name ultimate">R (궁극기) -
									${champ.skills.skillRName}</div>
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

				<div class="info-section" id="comments" style="margin-top: 40px;">
				    <h4>챔피언 평가 / 팁</h4>
				
				    <input type="hidden" id="targetNo" value="${champ.champNo}">
				    
				
				    <div class="comment-input-box" style="display: flex; gap: 10px; margin-bottom: 20px;">
				        <input type="text" id="replyContent" placeholder="이 챔피언에 대한 팁이나 평가를 남겨주세요!" 
				               style="flex: 1; padding: 12px; border: 1px solid #cbd5e1; border-radius: 6px; outline: none;">
				        <button type="button" onclick="insertInfoReply()" 
				                style="padding: 12px 24px; background: #3b82f6; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: bold;">
				            등록
				        </button>
				    </div>
				
				    <div class="comment-row" style="background: #f8fafc; padding: 12px; border-top: 2px solid #1e293b; border-bottom: 1px solid #e2e8f0; font-weight: bold; color: #475569; display: flex;">
				        <div style="flex: 2; text-align: center;">글쓴이</div>
				        <div class="comment-main" style="flex: 6; padding-left: 20px;">내용</div>
				        <div class="comment-side" style="flex: 2; text-align: center;">작성일</div>
				    </div>
				
				    <div id="replyList">
				        </div>
				</div>
			</div>
		</main>

		<aside class="side-right">
			<div class="side-card">
				<h3>챔피언 팁</h3>
				<div class="side-card-desc">상대 라이너와의 상성을 확인하고 룬 세팅을 변경해보세요.</div>
			</div>
			<div class="side-card">
				<h3>최근 업데이트</h3>
				<div class="side-card-desc">최신 업데이트 내용을 확인하세요.</div>
			</div>
		</aside>
	</div>

	<%@ include file="../common/footer.jsp"%>
	
	<script>
    // 1. 페이지 로딩 완료 시 자동으로 댓글 목록 조회
    $(document).ready(function() {
        loadInfoReplyList();
        
        // 엔터키 쳤을 때 댓글 등록되게 하는 편의 기능
        $("#replyContent").on("keyup", function(e) {
            if (e.key === "Enter") insertInfoReply();
        });
    });

    // 2. 댓글 목록 조회 (AJAX GET)
    function loadInfoReplyList() {
        const targetNo = $("#targetNo").val();

        $.ajax({
            url: "${pageContext.request.contextPath}/lol/replyList",
            type: "GET",
            data: { targetNo: targetNo },
            success: function(res) {
                let html = "";
                if (res.length === 0) {
                    html = "<div style='padding: 30px; text-align: center; color: #94a3b8;'>아직 작성된 팁이 없습니다. 첫 번째 팁을 남겨보세요!</div>";
                } else {
                    $.each(res, function(i, item) {
                        html += "<div class='comment-item' style='display: flex; padding: 15px 12px; border-bottom: 1px solid #f1f5f9; align-items: center;'>";
                        html += "  <div style='flex: 2; text-align: center; font-weight: bold; color: #1e293b;'>" + item.userName + "</div>";
                        html += "  <div style='flex: 6; padding-left: 20px; color: #334155; word-break: break-all;'>" + item.replyContent + "</div>";
                        
                        // 날짜 예쁘게 자르기
                        const dateObj = new Date(item.replyDate);
                        const dateStr = dateObj.getFullYear() + "." + String(dateObj.getMonth() + 1).padStart(2, '0') + "." + String(dateObj.getDate()).padStart(2, '0');
                        
                        // ✨ 날짜 하단에 [삭제] 버튼 추가 (INFO_REPLY_NO를 인자로 넘김)
                        html += "  <div style='flex: 2; text-align: center; color: #94a3b8; font-size: 13px;'>" 
                              + dateStr 
                              + "<br><span onclick='deleteInfoReply(" + item.infoReplyNo + ")' style='cursor:pointer; color:#ef4444; font-size:11px; margin-top:5px; display:inline-block;'>[삭제]</span>"
                              + "</div>";
                        html += "</div>";
                    });
                }
                $("#replyList").html(html);
            },
            error: function() {
                console.log("댓글 목록을 불러오는데 실패했습니다.");
            }
        });
    }

    // 3. 댓글 등록 (AJAX POST)
    function insertInfoReply() {
        const targetNo = $("#targetNo").val();
        const content = $("#replyContent").val();

        if (content.trim() === "") {
            alert("팁 내용을 입력해주세요.");
            $("#replyContent").focus();
            return;
        }

        const token = $("meta[name='_csrf']").attr("content");
        const header = $("meta[name='_csrf_header']").attr("content");

        $.ajax({
            url: "${pageContext.request.contextPath}/lol/insertReply",
            type: "POST",
            beforeSend: function(xhr) {
                if (header && token) xhr.setRequestHeader(header, token);
            },
            data: {
                targetNo: targetNo,
                replyContent: content
            },
            success: function(res) {
                if (res === "success") {
                    $("#replyContent").val(""); 
                    loadInfoReplyList(); // 목록 갱신
                } else if (res === "login") {
                    alert("로그인 후 이용 가능합니다.");
                } else {
                    alert("댓글 등록에 실패했습니다.");
                }
            },
            error: function(xhr) {
                if(xhr.status === 403) alert("세션이 만료되었거나 로그인 상태가 아닙니다.");
                else alert("서버 오류가 발생했습니다.");
            }
        });
    }

    // 4. ✨ 댓글 삭제 (AJAX POST)
    function deleteInfoReply(infoReplyNo) {
        if (!confirm("정말 이 팁을 삭제하시겠습니까?")) return;

        const token = $("meta[name='_csrf']").attr("content");
        const header = $("meta[name='_csrf_header']").attr("content");

        $.ajax({
            url: "${pageContext.request.contextPath}/lol/deleteReply", // 방금 만든 컨트롤러 주소!
            type: "POST",
            beforeSend: function(xhr) {
                if (header && token) xhr.setRequestHeader(header, token);
            },
            data: { infoReplyNo: infoReplyNo },
            success: function(res) {
                if (res === "success") {
                    alert("삭제되었습니다.");
                    loadInfoReplyList(); // 화면 즉시 갱신
                } else if (res === "login") {
                    alert("로그인이 필요한 서비스입니다.");
                } else {
                    alert("본인이 작성한 팁만 삭제할 수 있습니다."); // 서버에서 본인 글이 아니라 0건 업데이트 된 경우
                }
            },
            error: function() {
                alert("서버 통신 중 오류가 발생했습니다.");
            }
        });
    }
</script>
</body>
</html>