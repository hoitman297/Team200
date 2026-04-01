<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/member/comment_edit/style.css">
    
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<%--     <script src="${pageContext.request.contextPath}/resources/member/comment_edit/style.css"></script> --%>
    
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    
    <title>LOG.GG - 댓글 수정 및 삭제 관리</title>
</head>
<body>

<div class="manage-container">
    <div class="header">
        <h2>📝 나의 댓글 관리</h2>
        <div class="stats">작성한 댓글 총 <b>${totalReplyCount}개</b></div>
    </div>

    <div class="control-bar">
        <button class="btn btn-delete-selected" onclick="deleteSelected()">선택 삭제</button>
    </div>

    <table>
        <thead>
            <tr>
                <th class="col-check"><input type="checkbox" id="checkAll"></th>
                <th class="col-content">내용</th>
                <th class="col-date">날짜</th>
                <th class="col-action">관리</th>
            </tr>
        </thead>
        <tbody id="commentTableBody">
            <c:choose>
                <%-- 댓글이 없는 경우 --%>
                <c:when test="${empty list}">
                    <tr>
                        <td colspan="4" style="text-align:center; padding: 50px 0; color: #94a3b8;">
                            작성한 댓글이 없습니다.
                        </td>
                    </tr>
                </c:when>
                
                <%-- 댓글 목록 출력 --%>
                <c:otherwise>
                    <c:forEach var="item" items="${list}">
                        <tr>
                            <td class="col-check">
                                <%-- ✨ 체크박스 value에 댓글 번호(REPLY_NO)를 담습니다 --%>
                                <input type="checkbox" class="chk" value="${item.REPLY_NO}">
                            </td>
                            <td class="col-content">
                                <span class="text-view"><c:out value="${item.REPLY_CONTENT}"/></span>
                                <%-- 원문 게시글로 이동하는 링크 --%>
                                <a href="${pageContext.request.contextPath}/board/view?boardNo=${item.BOARD_NO}" class="original-post" target="_blank">
                                    원문: <c:out value="${item.BOARD_TITLE}"/>
                                </a>
	                            </td>
	                            <td class="col-date">
	                                <fmt:formatDate value="${item.REPLY_DATE}" pattern="yyyy.MM.dd"/>
	                            </td>
                            <td class="col-action">
                                <%-- 개별 삭제 버튼 --%>
                                <span class="action-link delete" onclick="deleteSingle(${item.REPLY_NO})">삭제</span>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
<!--                     <span class="action-link delete" onclick="deleteRow">삭제</span> -->
    </table>

    <button class="btn btn-prev" onclick="location.href='${pageContext.request.contextPath}/member/mypage'">이전 페이지</button>
</div>
	<script>
    // 1. 전체 선택/해제
    $(document).on('change', '#checkAll', function() {
        $('.chk').prop('checked', $(this).is(':checked'));
    });

    // 2. 선택 삭제
    function deleteSelected() {
        const checked = $('.chk:checked');
        if (checked.length === 0) {
            alert("삭제할 댓글을 선택해주세요.");
            return;
        }

        if (!confirm(checked.length + "개의 댓글을 삭제하시겠습니까?")) return;

        const replyNos = [];
        checked.each(function() {
            replyNos.push($(this).val());
        });

        sendDeleteRequest(replyNos);
    }

    // 3. 단건 삭제
    function deleteSingle(replyNo) {
        if (!confirm("이 댓글을 삭제하시겠습니까?")) return;
        sendDeleteRequest([replyNo]);
    }

    // 4. ✨ 핵심 AJAX 전송 함수
    function sendDeleteRequest(replyNos) {
    // ✨ 메타 태그에서 토큰 읽어오기
    const token = $("meta[name='_csrf']").attr("content");
    const header = $("meta[name='_csrf_header']").attr("content");

    $.ajax({
        url: "${pageContext.request.contextPath}/member/deleteReplies",
        type: "POST",
        traditional: true,
        // ✨ 헤더에 CSRF 토큰 추가
        beforeSend: function(xhr) {
            if(header && token) {
                xhr.setRequestHeader(header, token);
            }
        },
        data: { replyNos: replyNos },
        success: function(res) {
            if (res === "success") {
                alert("성공적으로 삭제되었습니다.");
                location.reload();
            } else {
                alert("삭제 실패 다시 시도해주세요.");
            }
        },
        error: function(xhr, status, error) {
            // 상세 에러 확인을 위해 로그 추가
            console.log("에러 코드 : " + xhr.status); // 403이면 CSRF 문제임
            alert("서버와 통신 중 에러가 발생했습니다.");
        }
    });
}
</script>
</body>
</html>