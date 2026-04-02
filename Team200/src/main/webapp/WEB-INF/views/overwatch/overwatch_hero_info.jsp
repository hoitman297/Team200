<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="gameId" value="overwatch" />
<c:set var="currentGameName" value="오버워치" />
<c:set var="headerTitle" value="오버워치" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
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

               <div class="info-section" id="comments" style="margin-top: 40px;">
			    <h4>영웅 평가 / 팁</h4>
			
			    <input type="hidden" id="targetNo" value="${hero.heroNo}">
			    
			    <div class="comment-input-box" style="display: flex; gap: 10px; margin-bottom: 20px;">
			        <input type="text" id="replyContent" placeholder="이 영웅에 대한 팁이나 평가를 남겨주세요!" 
			               style="flex: 1; padding: 12px; border: 1px solid #cbd5e1; border-radius: 6px; outline: none;">
			        <button type="button" onclick="insertInfoReply(0)" 
			                style="padding: 12px 24px; background: #f97316; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: bold;">
			            등록
			        </button>
			    </div>
			
			    <div class="comment-row" style="background: #f8fafc; padding: 12px; border-top: 2px solid #1e293b; border-bottom: 1px solid #e2e8f0; font-weight: bold; color: #475569; display: flex; font-size: 13px;">
			        <div style="flex: 2; text-align: center;">글쓴이</div>
			        <div style="flex: 5; padding-left: 20px;">내용</div>
			        <div style="flex: 3; text-align: center;">작성일 | 관리</div>
			    </div>
			
			    <div id="replyList"></div>
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
    
	<script>
    // [1] 페이지 로딩 시 초기화
    $(document).ready(function() {
        // 1. 댓글 목록 불러오기
        loadInfoReplyList();
        
        // 2. 메인 입력창에서 엔터키 누르면 등록 실행
        $("#replyContent").on("keyup", function(e) {
            if (e.key === "Enter") insertInfoReply(0); // 0은 일반 댓글
        });
    });

    // [2] 영웅 댓글 목록 조회 (AJAX GET)
    function loadInfoReplyList() {
        const targetNo = $("#targetNo").val();

        $.ajax({
            url: "${pageContext.request.contextPath}/ow/replyList",
            type: "GET",
            data: { targetNo: targetNo },
            success: function(res) {
                let html = "";
                if (res.length === 0) {
                    html = "<div style='padding: 40px; text-align: center; color: #94a3b8;'>이 영웅에 대한 첫 번째 팁을 남겨보세요!</div>";
                } else {
                    $.each(res, function(i, item) {
                        // 대댓글 여부에 따른 스타일 (오버워치 테마: 연한 주황색 배경)
                        const isChild = item.parentReplyNo > 0;
                        const rowStyle = isChild ? "background: #fff7ed; padding-left: 50px;" : "background: white;";
                        const icon = isChild ? "↳ " : "";

                        html += "<div class='comment-item' style='display: flex; padding: 15px 12px; border-bottom: 1px solid #f1f5f9; align-items: center; " + rowStyle + "'>";
                        html += "  <div style='flex: 2; text-align: center; font-weight: bold; color: #1e293b; font-size: 13px;'>" + icon + item.userName + "</div>";
                        html += "  <div style='flex: 5; padding-left: 20px; color: #334155; word-break: break-all; font-size: 14px;'>" + item.replyContent + "</div>";
                        
                        // 날짜 변환
                        const dateObj = new Date(item.replyDate);
                        const dateStr = dateObj.getFullYear() + "." + String(dateObj.getMonth() + 1).padStart(2, '0') + "." + String(dateObj.getDate()).padStart(2, '0');
                        
                        html += "  <div style='flex: 3; text-align: center; color: #94a3b8; font-size: 12px;'>";
                        html += "    " + dateStr + " | ";
                        
                        // 버튼 구성 (답글은 원본 댓글에만)
                        if(!isChild) {
                            html += "<span onclick='toggleReplyForm(" + item.infoReplyNo + ")' style='cursor:pointer; color:#3b82f6;'>답글</span>";
                        }
                        html += "<span onclick='deleteInfoReply(" + item.infoReplyNo + ")' style='cursor:pointer; color:#ef4444; margin: 0 5px;'>삭제</span>";
                        html += "<span onclick='reportReply(" + item.infoReplyNo + ")' style='cursor:pointer; color:#64748b;'>신고</span>";
                        html += "  </div>";
                        html += "</div>";

                        // 답글(대댓글) 입력 폼 (토글 대상)
                        html += "<div id='replyForm_" + item.infoReplyNo + "' style='display:none; padding: 10px 10px 10px 50px; background: #fff7ed; border-bottom: 1px solid #fed7aa;'>";
                        html += "  <div style='display: flex; gap: 10px;'>";
                        html += "    <input type='text' id='childContent_" + item.infoReplyNo + "' placeholder='답글 입력...' style='flex: 1; padding: 8px; border: 1px solid #cbd5e1; border-radius: 4px; font-size: 13px;'>";
                        html += "    <button onclick='insertInfoReply(" + item.infoReplyNo + ")' style='padding: 8px 15px; background: #f97316; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 12px;'>등록</button>";
                        html += "  </div>";
                        html += "</div>";
                    });
                }
                $("#replyList").html(html);
            },
            error: function() { console.error("목록 로드 오류"); }
        });
    }

    // [3] 댓글 및 답글 등록 (AJAX POST)
    function insertInfoReply(parentNo) {
        const targetNo = $("#targetNo").val();
        // 부모 번호(parentNo)가 0이면 메인 입력창, 아니면 해당 답글 입력창에서 값 추출
        const content = (parentNo === 0) ? $("#replyContent").val() : $("#childContent_" + parentNo).val();

        if (content.trim() === "") {
            alert("내용을 입력해주세요.");
            return;
        }

        // 스프링 시큐리티 CSRF 토큰 준비
        const token = $("meta[name='_csrf']").attr("content");
        const header = $("meta[name='_csrf_header']").attr("content");

        $.ajax({
            url: "${pageContext.request.contextPath}/ow/insertReply",
            type: "POST",
            beforeSend: function(xhr) {
                if (header && token) xhr.setRequestHeader(header, token);
            },
            data: {
                targetNo: targetNo,
                replyContent: content,
                parentReplyNo: parentNo // VO 필드명과 일치
            },
            success: function(res) {
                if (res === "success") {
                    if(parentNo === 0) $("#replyContent").val(""); // 메인 입력창 비우기
                    loadInfoReplyList(); // 목록 새로고침
                } else if (res === "login") {
                    alert("로그인이 필요합니다.");
                } else {
                    alert("등록에 실패했습니다.");
                }
            },
            error: function() { alert("서버와 통신 중 오류가 발생했습니다."); }
        });
    }

    // [4] 답글창 열기/닫기 (토글)
    function toggleReplyForm(no) {
        $("#replyForm_" + no).slideToggle("fast");
    }

    // [5] 댓글/답글 삭제
    function deleteInfoReply(no) {
        if (!confirm("정말 이 내용을 삭제하시겠습니까?")) return;

        const token = $("meta[name='_csrf']").attr("content");
        const header = $("meta[name='_csrf_header']").attr("content");

        $.ajax({
            url: "${pageContext.request.contextPath}/ow/deleteReply",
            type: "POST",
            beforeSend: function(xhr) {
                if (header && token) xhr.setRequestHeader(header, token);
            },
            data: { infoReplyNo: no },
            success: function(res) {
                if (res === "success") {
                    alert("삭제되었습니다.");
                    loadInfoReplyList();
                } else {
                    alert("본인이 작성한 글만 삭제할 수 있습니다.");
                }
            }
        });
    }

    // [6] 신고 기능 (UI 연동용)
    function reportReply(no) {
        alert(no + "번 댓글에 대한 신고를 접수하시겠습니까? (현재 접수 시스템 준비 중)");
    }
</script>
</body>
</html>