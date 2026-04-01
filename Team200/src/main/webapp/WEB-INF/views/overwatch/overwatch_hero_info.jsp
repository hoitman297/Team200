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
				        <button type="button" onclick="insertInfoReply()" 
				                style="padding: 12px 24px; background: #f97316; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: bold;">
				            등록
				        </button>
				    </div>
				
				    <div class="comment-row" style="background: #f8fafc; padding: 12px; border-top: 2px solid #1e293b; border-bottom: 1px solid #e2e8f0; font-weight: bold; color: #475569; display: flex;">
				        <div style="flex: 2; text-align: center;">글쓴이</div>
				        <div class="comment-main" style="flex: 6; padding-left: 20px;">내용</div>
				        <div class="comment-side" style="flex: 2; text-align: center;">작성일</div>
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
	$(document).ready(function() {
	    loadInfoReplyList();
	    $("#replyContent").on("keyup", function(e) {
	        if (e.key === "Enter") insertInfoReply();
	    });
	});
	
	function loadInfoReplyList() {
	    const targetNo = $("#targetNo").val();
	    $.ajax({
	        url: "${pageContext.request.contextPath}/ow/replyList",
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
	                    
	                    const dateObj = new Date(item.replyDate);
	                    const dateStr = dateObj.getFullYear() + "." + String(dateObj.getMonth() + 1).padStart(2, '0') + "." + String(dateObj.getDate()).padStart(2, '0');
	                    
	                    html += "  <div style='flex: 2; text-align: center; color: #94a3b8; font-size: 13px;'>" 
	                          + dateStr 
	                          + "<br><span onclick='deleteInfoReply(" + item.infoReplyNo + ")' style='cursor:pointer; color:#ef4444; font-size:11px; margin-top:5px; display:inline-block;'>[삭제]</span>"
	                          + "</div>";
	                    html += "</div>";
	                });
	            }
	            $("#replyList").html(html);
	        }
	    });
	}
	
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
	        url: "${pageContext.request.contextPath}/ow/insertReply",
	        type: "POST",
	        beforeSend: function(xhr) {
	            if (header && token) xhr.setRequestHeader(header, token);
	        },
	        data: { targetNo: targetNo, replyContent: content },
	        success: function(res) {
	            if (res === "success") {
	                $("#replyContent").val(""); 
	                loadInfoReplyList(); 
	            } else if (res === "login") {
	                alert("로그인 후 이용 가능합니다.");
	            } else {
	                alert("댓글 등록에 실패했습니다.");
	            }
	        }
	    });
	}
	
	function deleteInfoReply(infoReplyNo) {
	    if (!confirm("정말 이 팁을 삭제하시겠습니까?")) return;
	
	    const token = $("meta[name='_csrf']").attr("content");
	    const header = $("meta[name='_csrf_header']").attr("content");
	
	    $.ajax({
	        url: "${pageContext.request.contextPath}/ow/deleteReply",
	        type: "POST",
	        beforeSend: function(xhr) {
	            if (header && token) xhr.setRequestHeader(header, token);
	        },
	        data: { infoReplyNo: infoReplyNo },
	        success: function(res) {
	            if (res === "success") {
	                alert("삭제되었습니다.");
	                loadInfoReplyList();
	            } else if (res === "login") {
	                alert("로그인이 필요한 서비스입니다.");
	            } else {
	                alert("본인이 작성한 팁만 삭제할 수 있습니다."); 
	            }
	        }
	    });
	}
	</script>
</body>
</html>