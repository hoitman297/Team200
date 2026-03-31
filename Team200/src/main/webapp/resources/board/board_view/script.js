$(document).ready(function() {
    // 공감 버튼 클릭 이벤트
    $("#btn-like").click(function() {
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        var boardNo = $(this).data("boardno");

        $.ajax({
            url: contextPath + "/board/addLike",
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

    // 페이지 로딩 시 댓글 목록 초기화
    selectReplyList();
});

// 댓글 목록 조회 함수
function selectReplyList() {
    $.ajax({
        url: contextPath + "/board/reply/list",
        data: { boardNo: currentBoardNo }, // JSP에서 선언한 전역 변수 사용
        success: function(list) {
            $("#reply-count-display").text("댓글 " + list.length);
            
            let html = "";
            if(list.length === 0) {
                html = "<div style='text-align: center; color: #94a3b8; padding: 20px 0;'>첫 번째 댓글을 남겨보세요!</div>";
            } else {
                for(let i=0; i<list.length; i++) {
                    html += "<div class='comment-item'>";
                    html += "    <div class='comment-author'>" + list[i].userName + "</div>";
                    html += "    <div class='comment-text'>" + list[i].replyContent + "</div>";
                    html += "    <div class='comment-utils'>";
                    html += "        <span style='color: #94a3b8; font-size: 12px; margin-right: 15px;'>" + list[i].replyDate + "</span>";
                    html += "        <span style='cursor:pointer;'>답글</span> | <span style='cursor:pointer;'>신고</span> | <span style='cursor:pointer;'>삭제</span>";
                    html += "    </div>";
                    html += "</div>";
                }
            }
            $("#reply-list-area").html(html);
        },
        error: function() {
            console.log("댓글 목록 조회 실패");
        }
    });
}

// 댓글 등록 함수
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
        url: contextPath + "/board/reply/insert",
        type: "POST",
        data: { 
            boardNo: currentBoardNo, // JSP에서 선언한 전역 변수 사용
            replyContent: content 
        },
        beforeSend: function(xhr) {
            xhr.setRequestHeader(header, token);
        },
        success: function(result) {
            if(result === "success") {
                $("#replyContent").val("");
                selectReplyList(); // 댓글 등록 후 목록 새로고침
            } else if(result === "login") {
                alert("로그인 후 이용 가능합니다.");
                location.href = contextPath + "/member/login";
            } else {
                alert("댓글 등록에 실패했습니다.");
            }
        },
        error: function() {
            alert("댓글 등록 중 서버 오류가 발생했습니다.");
        }
    });
}

// 게시글 삭제 확인 및 폼 전송 함수
function deleteBoard() {
    if(confirm("정말로 이 게시글을 삭제하시겠습니까? (삭제 후 복구할 수 없습니다)")) {
        document.getElementById("deleteForm").submit();
    }
}