<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<%-- 게임 이름 및 경로 설정 --%>
<c:set var="safeGameId" value="${fn:toLowerCase(board.gameCode)}" />
<c:choose>
    <c:when test="${board.gameCode == 'BG'}">
        <c:set var="gameName" value="배틀그라운드"/>
        <c:set var="safeGameId" value="battleground"/>
    </c:when>
    <c:when test="${board.gameCode == 'OW'}">
        <c:set var="gameName" value="오버워치"/>
        <c:set var="safeGameId" value="overwatch"/>
    </c:when>
    <c:otherwise>
        <c:set var="gameName" value="리그 오브 레전드"/>
        <c:set var="safeGameId" value="lol"/>
    </c:otherwise>
</c:choose>
<c:set var="boardTypePath" value="${fn:contains(board.categoryName, '공략') ? 'strategy' : 'free'}" />

<%-- 로그인한 유저 번호 추출 --%>
<c:set var="secUserNo" value="0" />
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal.userNo" var="secUserNo" />
</sec:authorize>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <%-- AJAX 요청을 위한 CSRF 메타 태그 --%>
    <sec:csrfMetaTags />
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    
    <title>LOG.GG - ${board.boardTitle}</title>

    <%-- CSS 파일 불러오기 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/board_view/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    
    <%-- jQuery 불러오기 --%>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

    <%-- 외부 JS 파일에서 사용할 전역 변수 선언 --%>
    <script>
        const contextPath = "${pageContext.request.contextPath}";
        const currentBoardNo = ${board.boardNo};
    </script>
    
    <%-- 분리된 외부 JS 파일 불러오기 --%>
    <script src="${pageContext.request.contextPath}/resources/board/board_view/script.js" defer></script>
    <script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
</head>
<body>  
    <c:set var="headerTitle" value="${gameName}" />
    <%@ include file="../common/header.jsp" %>

    <div class="main-layout">
        <aside class="side-left">
            <div class="side-card">
                <h3>카테고리</h3>

                <a href="${pageContext.request.contextPath}/gallery/list" class="menu-link" style="text-decoration: none; color: inherit;">
                    <div class="menu-item">갤러리</div>
                </a>

                <div class="menu-item-group">
                    <div class="menu-item">게시판</div>
                    <div class="sub-menu-container"> 
                        <div class="sub-item ${boardTypePath == 'free' ? 'active' : ''}" onclick="location.href='<c:url value="/board/free_${safeGameId}"/>'">자유게시판</div>
                        <div class="sub-item ${boardTypePath == 'strategy' ? 'active' : ''}" onclick="location.href='<c:url value="/board/strategy_${safeGameId}"/>'">공략게시판</div>
                    </div>
                </div>
                
                <a href="${pageContext.request.contextPath}/board/inquiry" class="menu-link" style="text-decoration: none; color: inherit;">
                    <div class="menu-item">고객지원</div>
                </a>
            </div>
        </aside>

        <main class="content-area">
            <a href="<c:url value='/' />" style="text-decoration: none; color: inherit;">
                <div class="logo">LOG.GG</div>
            </a>

            <article class="view-container">
                <div class="post-header">
                    <div class="post-category">${board.categoryName}</div>
                    <h1 class="post-title">${board.boardTitle}</h1>
                    <div class="post-info">
                        <span>글쓴이: <b>${board.userName}</b></span>
                        <span>날짜: <b><fmt:formatDate value="${board.postDate}" pattern="yyyy-MM-dd HH:mm"/></b></span>
                        <span>조회수: <b>${board.readCount}</b></span>
                    </div>

                    <%-- CSS 로직에 맞춰 상단으로 이동한 우측 상단 수정/삭제 버튼 (.post-util-btns) --%>
                    <div class="post-util-btns">
                        <c:if test="${secUserNo != 0 and secUserNo == board.userNo}">
                            <button type="button" onclick="location.href='<c:url value="/board/edit?boardNo=${board.boardNo}"/>'">수정</button>
                            <button type="button" class="delete" onclick="if(confirm('정말 삭제하시겠습니까?')) { location.href='<c:url value="/board/delete?boardNo=${board.boardNo}"/>'; }">삭제</button>
                        </c:if>
                        <c:if test="${secUserNo != board.userNo}">
                            <sec:authorize access="hasRole('ADMIN')">
                                <button type="button" class="delete" onclick="if(confirm('관리자 권한으로 강제 삭제하시겠습니까?')) { location.href='<c:url value="/board/delete?boardNo=${board.boardNo}"/>'; }">삭제(관리자)</button>
                            </sec:authorize>
                        </c:if>
                    </div>
                </div>

                <div class="post-body" style="white-space: pre-wrap; line-height: 1.6;">${board.boardContent}
                    <c:if test="${not empty board.fileList}">
                        <div class="post-images" style="margin-top: 20px; text-align: center;">
                            <c:forEach var="file" items="${board.fileList}">
                                <img src="<c:url value='/resources/upload/board/${file.changeName}'/>" 
                                     alt="첨부 이미지" 
                                     style="max-width: 100%; height: auto; margin-bottom: 15px; border-radius: 8px;">
                            </c:forEach>
                        </div>
                    </c:if>
                </div>

                <div class="post-action">
                    <button type="button" class="btn-action like" id="btn-like" data-boardno="${board.boardNo}">
                        👍 공감 <b id="like-count">${board.likeCount}</b>
                    </button>
                    <button class="btn-action" onclick="location.href='<c:url value="/board/${boardTypePath}_${safeGameId}"/>'">목록으로</button>
                    <button class="btn-action report">🚨 신고</button>
                </div>

                <%-- 게시글 삭제용 숨김 폼 --%>
                <form id="deleteForm" action="<c:url value='/board/delete'/>" method="POST" style="display:none;">
                    <input type="hidden" name="boardNo" value="${board.boardNo}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                </form>

                <%-- 댓글 섹션 --%>
                <section class="comment-section">
                    <div class="comment-count" id="reply-count-display">댓글 0</div>
                    
                    <div class="comment-form">
                        <textarea id="replyContent" placeholder="댓글을 남겨보세요."></textarea>
                        <button type="button" class="comment-submit" onclick="insertReply();">등록</button>
                    </div>
                
                    <div class="comment-list" id="reply-list-area">
                        <%-- 초기 댓글 렌더링 영역 (JSTL은 그대로 유지) --%>
                        <c:choose>
                            <c:when test="${empty replyList}">
                                <div style="text-align: center; color: var(--text-sub); padding: 30px 0;">첫 번째 댓글을 남겨보세요!</div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="reply" items="${replyList}">
                                    <c:set var="rootId" value="${reply.parentReplyNo > 0 ? reply.parentReplyNo : reply.replyNo}" />
                                
                                    <c:choose>
                                        <c:when test="${reply.status == 'N'}">
                                            <div class="comment-item" style="color: #cbd5e1;">
                                                <div class="comment-author"></div>
                                                <div class="comment-text">🚫 삭제된 댓글입니다.</div>
                                                <div class="comment-utils"></div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="comment-item ${reply.parentReplyNo > 0 ? 'reply' : ''}">
                                                <div class="comment-author">
                                                    ${reply.parentReplyNo > 0 ? '↳ ' : ''}${reply.userName}
                                                </div>
                                                <div class="comment-text">${reply.replyContent}</div>
                                                
                                                <div class="comment-utils" style="white-space: nowrap; flex-shrink: 0;">
                                                    <span><fmt:formatDate value="${reply.replyDate}" pattern="yyyy.MM.dd HH:mm" /></span>
                                                    
                                                    <span style="cursor:pointer;" onclick="toggleReplyForm(${reply.replyNo})">답글</span> | 
                                                    <span style="cursor:pointer;">신고</span> | 
                                                    <span style="cursor:pointer;" onclick="deleteReply(${reply.replyNo})">삭제</span>
                                                </div>
                                            </div>
                                
                                            <div id="nested-form-${reply.replyNo}" class="comment-form" style="display: none; margin-left: 40px; margin-bottom: 0; padding: 15px;">
                                                <textarea id="nested-content-${reply.replyNo}" placeholder="답글을 남겨보세요." style="height: 50px;"></textarea>
                                                <button type="button" class="comment-submit" onclick="insertNestedReply(${reply.replyNo}, ${rootId})" style="padding: 8px 16px;">등록</button>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>
            </article>
        </main>
        
        <aside class="side-right">
        </aside>
    </div>
    
    <footer>© 2026 LOG.GG 배틀그라운드 서비스. 모든 권리 보유.</footer>

    <%-- 스크립트 로직 --%>
    <script>
    const loginUserNo = "${secUserNo}";
    
    let isAdmin = false;
    <sec:authorize access="hasRole('ADMIN')">
        isAdmin = true;
    </sec:authorize>
    
    $(document).ready(function() {
        
        selectReplyList();
        
        $("#btn-like").click(function() {
            var token = $("meta[name='_csrf']").attr("content");
            var header = $("meta[name='_csrf_header']").attr("content");
            var boardNo = $(this).data("boardno");
    
            $.ajax({
                url: "<c:url value='/board/addLike'/>",
                type: "POST",
                data: { boardNo: boardNo },
                beforeSend: function(xhr) {
                    xhr.setRequestHeader(header, token);
                },
                success: function(result) {
                    if(result.status === "success") {
                        $("#like-count").text(result.newLikeCount);
                        alert("게시글에 공감했습니다! 👍");
                    } else if (result.status === "already") {
                        alert(result.message); 
                    } else {
                        alert(result.message);
                    }
                },
                error: function() {
                    alert("서버와 통신 중 문제가 발생했습니다.");
                }
            });
        });
    });
    
    function selectReplyList() {
        $.ajax({
            url: "${pageContext.request.contextPath}/board/reply/list",
            data: { boardNo: ${board.boardNo} },
            success: function(list) {
                
                let activeCount = list.filter(r => r.status === 'Y').length;
                $("#reply-count-display").html("댓글 " + activeCount);
                
                let html = "";
                if(list.length === 0) {
                    html = "<div style='text-align: center; color: #94a3b8; padding: 30px 0;'>첫 번째 댓글을 남겨보세요!</div>";
                } else {
                    for(let i=0; i<list.length; i++) {
                        let r = list[i];
                        let rootId = r.parentReplyNo > 0 ? r.parentReplyNo : r.replyNo;
                        
                        if (r.status === 'N') {
                            html += "<div class='comment-item' style='color: #cbd5e1;'>";
                            html += "    <div class='comment-author'></div>";
                            html += "    <div class='comment-text'>🚫 삭제된 댓글입니다.</div>";
                            html += "    <div class='comment-utils'></div>";
                            html += "</div>";
                        } else {
                            let isReplyClass = r.parentReplyNo > 0 ? "reply" : "";
                            let arrow = r.parentReplyNo > 0 ? "↳ " : "";
    
                            html += "<div class='comment-item " + isReplyClass + "'>";
                            html += "    <div class='comment-author'>" + arrow + r.userName + "</div>";
                            html += "    <div class='comment-text'>" + r.replyContent + "</div>";
                            
                            html += "    <div class='comment-utils' style='white-space: nowrap; flex-shrink: 0;'>";
                            html += "        <span style='color: #94a3b8; font-size: 12px; margin-right: 15px;'>" + r.replyDate + "</span>";
                            html += "        <span style='cursor:pointer;' onclick='toggleReplyForm(" + r.replyNo + ")'>답글</span> | ";
                            html += "        <span style='cursor:pointer;'>신고</span>";
                            
                            if((loginUserNo && loginUserNo == r.userNo) || isAdmin) {
                                html += " | <span style='cursor:pointer;' onclick='deleteReply(" + r.replyNo + ")'>삭제</span>";
                            }
                            
                            html += "    </div>";
                            html += "</div>";
    
                            html += "<div id='nested-form-" + r.replyNo + "' class='comment-form' style='display: none; margin-top: 5px; margin-left: 40px; margin-bottom: 10px; padding: 15px;'>";
                            html += "    <textarea id='nested-content-" + r.replyNo + "' placeholder='답글을 남겨보세요.' style='height: 50px;'></textarea>";
                            html += "    <button type='button' class='comment-submit' onclick='insertNestedReply(" + r.replyNo + ", " + rootId + ")' style='padding: 8px 16px;'>등록</button>";
                            html += "</div>";
                        }
                    }
                }
                
                $("#reply-list-area").html(html);
            },
            error: function() {
                console.log("댓글 목록 조회 실패");
            }
        });
    }
    
    function insertReply() {
        let content = $("#replyContent").val();
        
        if(content.trim() === "") {
            alert("댓글 내용을 입력해주세요!");
            $("#replyContent").focus();
            return;
        }
    
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
    
        $.ajax({
            url: "${pageContext.request.contextPath}/board/reply/insert",
            type: "POST",
            data: { 
                boardNo: ${board.boardNo}, 
                replyContent: content 
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader(header, token);
            },
            success: function(result) {
                if(result === "success") {
                    $("#replyContent").val(""); 
                    selectReplyList(); 
                } else if(result === "login") {
                    alert("로그인 후 이용 가능합니다.");
                    location.href = "${pageContext.request.contextPath}/member/login";
                } else {
                    alert("댓글 등록에 실패했습니다.");
                }
            },
            error: function() {
                alert("댓글 등록 중 서버 오류가 발생했습니다.");
            }
        });
    }
    
    function toggleReplyForm(replyNo) {
        let form = $("#nested-form-" + replyNo);
        form.slideToggle(200, function() {
            if(form.is(":visible")) {
                $("#nested-content-" + replyNo).focus();
            }
        });
    }
    
    function insertNestedReply(formId, rootParentNo) {
        let content = $("#nested-content-" + formId).val();
        
        if(content.trim() === "") {
            alert("답글 내용을 입력해주세요!");
            return;
        }
    
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
    
        $.ajax({
            url: "${pageContext.request.contextPath}/board/reply/insert",
            type: "POST",
            data: { 
                boardNo: ${board.boardNo}, 
                replyContent: content,
                parentReplyNo: rootParentNo 
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader(header, token); 
            },
            success: function(result) {
                if(result === "success") {
                    window.location.reload();
                } else if(result === "login") {
                    alert("로그인 후 이용 가능합니다.");
                }
            },
            error: function() { alert("답글 등록에 실패했습니다."); }
        });
    }
    
    function deleteReply(replyNo) {
        if(!confirm("정말로 이 댓글을 삭제하시겠습니까?")) {
            return;
        }
    
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
    
        $.ajax({
            url: "${pageContext.request.contextPath}/board/reply/delete",
            type: "POST",
            data: { 
                replyNo: replyNo,
                userNo: loginUserNo
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader(header, token); 
            },
            success: function(result) {
                if(result === "success") {
                    selectReplyList(); 
                } else if(result === "login") {
                    alert("로그인 후 이용 가능합니다.");
                } else {
                    alert("삭제 실패! 권한이 없거나 이미 삭제된 댓글입니다.");
                }
            },
            error: function() { alert("통신 중 오류가 발생했습니다."); }
        });
    }
    </script>
</body>
</html>