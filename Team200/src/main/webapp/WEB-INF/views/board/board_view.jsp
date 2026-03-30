<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/board/board_view/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/main/style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/board/board_view/script.js"></script>
	<script src="${pageContext.request.contextPath}/resources/main/script.js" defer></script>
    
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    
    <title>LOG.GG - ${board.boardTitle}</title>
</head>
<body>	
<c:set var="headerTitle" value="게시판" />
<%@ include file="../common/header.jsp" %>

    <div class="main-layout">
        <aside class="side-left">
            <div class="side-card">
                <h3>카테고리</h3>
                <div class="menu-item" onclick="location.href='gallery.html'">갤러리</div>
                
                <div class="menu-item-group">
                    <div class="menu-item">게시판</div>
                    <div class="sub-menu-container"> 
                        <div class="sub-item ${boardTypePath == 'free' ? 'active' : ''}" onclick="location.href='<c:url value="/board/free_${safeGameId}"/>'">자유게시판</div>
                        <div class="sub-item" ${boardTypePath == 'strategy' ? 'active' : ''}" onclick="location.href='<c:url value="/board/strategy_${safeGameId}"/>'">공략게시판</div>
                    </div>
                </div>
                
                <div class="menu-item" onclick="location.href='qna-list.html'">고객지원</div>
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
                        <span>날짜: <b><fmt:formatDate value="${board.postDate}" pattern="yyyy-MM-dd:HH:mm"/></b></span>
                        <span>조회수: <b>${board.readCount}</b></span>
                    </div>
                </div>

                <div class="post-body" style="white-space: pre-wrap; line-height: 1.6;">${board.boardContent}
                    <c:if test="${not empty board.fileList}">
				        <div class="post-images" style="margin-top: 20px; text-align: center;">
				            <c:forEach var="file" items="${board.fileList}">
				                <%-- 업로드된 경로에 맞춰 이미지 태그 생성 --%>
				                <img src="<c:url value='/resources/upload/board/${file.changeName}'/>" 
				                     alt="첨부 이미지" 
				                     style="max-width: 100%; height: auto; margin-bottom: 15px; border-radius: 8px;">
				            </c:forEach>
				        </div>
				    </c:if>
                </div>

                <div class="post-action">
                    <%-- ✨ id와 data-boardno를 추가하고, 숫자가 바뀔 부분(like-count)도 id를 줍니다 --%>
					<button type="button" class="btn-action like" id="btn-like" data-boardno="${board.boardNo}">
					    👍 공감 <b id="like-count">${board.likeCount}</b>
					</button>
                    <button class="btn-action" onclick="location.href='<c:url value="/board/${boardTypePath}_${safeGameId}"/>'">목록으로</button>
                    <button class="btn-action report">🚨 신고</button>
                </div>

                <section class="comment-section">
				    <div class="comment-count" id="reply-count-display">댓글 0</div>
				    
				    <div class="comment-form">
				        <textarea id="replyContent" placeholder="댓글을 남겨보세요."></textarea>
				        <button type="button" class="comment-submit" onclick="insertReply();">등록</button>
				    </div>
				
				    <div class="comment-list" id="reply-list-area">
				        </div>

<!--                     <div class="comment-list"> -->
<!--                         <div class="comment-item"> -->
<!--                             <div class="comment-author">배그초보</div> -->
<!--                             <div class="comment-text">보통 수요일 오전 9시부터 오후 1시까지 하더라고요!</div> -->
<!--                             <div class="comment-utils"> -->
<!--                                 <span>답글</span> | <span>신고</span> | <span>공감</span> -->
<!--                             </div> -->
<!--                         </div> -->

<!--                         <div class="comment-item reply"> -->
<!--                             <div class="comment-author">ㄴ 글쓴이</div> -->
<!--                             <div class="comment-text">아하 그렇군요! 답변 감사합니다 :)</div> -->
<!--                             <div class="comment-utils"> -->
<!--                                 <span>신고</span> | <span>공감</span> -->
<!--                             </div> -->
<!--                         </div> -->
<!--                     </div> -->
                </section>
            </article>
        </main>

        <aside class="side-right">
            <div class="side-card">
                <h3>${gameName} 소식</h3>
                <p>
                    최신 패치노트와 공략을 확인하고<br>
                    승률을 높여보세요!<br>
                    현재 시즌 28 진행 중입니다.
                </p>
                <button class="btn-more">자세히 보기</button>
            </div>
        </aside>
    </div>

    <footer>© 2026 LOG.GG 배틀그라운드 서비스. 모든 권리 보유.</footer>
		<script>
		$(document).ready(function() {
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
		                    // 공감 성공: 숫자 업데이트 및 알림
		                    $("#like-count").text(result.newLikeCount);
		                    alert("게시글에 공감했습니다! 👍");
		                } else if (result.status === "already") {
		                    // 이미 공감함: 알림만 띄우기
		                    alert(result.message); 
		                } else {
		                    // 로그인 안됨 등 에러
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
		        data: { boardNo: ${board.boardNo} }, // 게시글 번호 전송
		        success: function(list) {
		            
		            // 총 댓글 수 업데이트
		            $("#reply-count-display").text("댓글 " + list.length);
		            
		            let html = "";
		            if(list.length === 0) {
		                html = "<div style='text-align: center; color: #94a3b8; padding: 20px 0;'>첫 번째 댓글을 남겨보세요!</div>";
		            } else {
		                for(let i=0; i<list.length; i++) {
		                    // 후배님의 기존 CSS 클래스(.comment-item, .comment-author 등)를 그대로 살립니다!
		                    html += "<div class='comment-item'>";
		                    html += "    <div class='comment-author'>" + list[i].userName + "</div>";
		                    html += "    <div class='comment-text'>" + list[i].replyContent + "</div>";
		                    html += "    <div class='comment-utils'>";
		                    html += "        <span style='color: #94a3b8; font-size: 12px; margin-right: 15px;'>" + list[i].replyDate + "</span>";
		                    // TODO: 나중에 이 부분에 진짜 기능 연결
		                    html += "        <span style='cursor:pointer;'>답글</span> | <span style='cursor:pointer;'>신고</span> | <span style='cursor:pointer;'>삭제</span>";
		                    html += "    </div>";
		                    html += "</div>";
		                }
		            }
		            
		            // 화면에 렌더링
		            $("#reply-list-area").html(html);
		        },
		        error: function() {
		            console.log("댓글 목록 조회 실패");
		        }
		    });
		}

		// 2. 댓글 등록 함수 (CSRF 토큰 필수!)
		function insertReply() {
		    let content = $("#replyContent").val();
		    
		    if(content.trim() === "") {
		        alert("댓글 내용을 입력해주세요!");
		        $("#replyContent").focus();
		        return;
		    }

		    // Security CSRF 토큰 세팅
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
		            xhr.setRequestHeader(header, token); // Post 요청 시 필수!
		        },
		        success: function(result) {
		            if(result === "success") {
		                $("#replyContent").val(""); // 입력창 비우기
		                selectReplyList(); // ✨ 목록 다시 불러와서 화면 새로고침 효과!
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
		</script>
</body>
</html>