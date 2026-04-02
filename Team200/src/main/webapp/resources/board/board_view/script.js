// 🚨 어떤 걸 신고하는지 기억할 전역 변수들
let currentReportType = ""; // "board" 또는 "reply"
let currentReportTargetNo = 0; // 글 번호 또는 댓글 번호

// HTML이 모두 준비된 후 실행되는 영역이에요!
$(document).ready(function() {
    // 기존에 있던 게시글 신고 클릭 이벤트는 이제 JSP에서 onclick으로 직접 부르기 때문에 지웠습니다!
    // (만약 다른 초기화 코드가 필요하시다면 이 안에 작성해 주시면 됩니다 🙇‍♂️)
}); 

// 1️⃣ 모달 창 열기 함수 (JSP에서 신고 버튼 누를 때 실행됨)
function openReportModal(type, targetNo) {
    currentReportType = type;
    currentReportTargetNo = targetNo;
    
    // 이전에 입력된 내용 초기화 후 모달 보여주기
    $("#reportReason").val("스팸홍보");
    $("#reportDetail").val("");
    $("#reportModal").fadeIn(200); // 0.2초 동안 부드럽게 짠!
}

// 2️⃣ 모달 창 닫기 함수
function closeReportModal() {
    $("#reportModal").fadeOut(200); // 0.2초 동안 부드럽게 스르륵~
}

// 3️⃣ 진짜 신고 접수하기 (모달 창에서 '신고 접수' 버튼 누를 때 실행됨)
function submitReport() {
    let reason = $("#reportReason").val();
    let detail = $("#reportDetail").val();
    
    // 보안(CSRF) 토큰 챙기기!
    var token = $("meta[name='_csrf']").attr("content");
    var header = $("meta[name='_csrf_header']").attr("content");
    
    // 게시글 신고인지, 댓글 신고인지에 따라 백엔드 주소 다르게 설정!
    let targetUrl = (currentReportType === "board") ? (contextPath + "/board/report") : (contextPath + "/board/reply/report");
    
    // 서버로 보낼 데이터 만들기
    let requestData = {
        reportReason: reason,
        reportDetail: detail
    };
    
    // 게시글 번호를 보낼지, 댓글 번호를 보낼지 결정!
    if(currentReportType === "board") {
        requestData.boardNo = currentReportTargetNo;
    } else {
        requestData.replyNo = currentReportTargetNo;
    }

    $.ajax({
        url: targetUrl,
        type: "POST",
        data: requestData,
        beforeSend: function(xhr) {
            xhr.setRequestHeader(header, token); // 보안 토큰 싣기
        },
        success: function(result) {
            // 서버에서 어떤 응답(result)을 주는지에 따라 알림 띄우기
            if(result === "success") {
                alert("신고가 정상적으로 접수되었습니다! 🚓\n(사유: " + reason + ")");
                closeReportModal(); // 성공하면 예쁜 팝업 창 닫기!
            } else if(result === "login") {
                alert("로그인 후 이용해주세요!");
            } else {
                alert("이미 신고하셨거나 오류가 발생했어요. 😥");
            }
        },
        error: function() {
            alert("서버와 통신 중 오류가 발생했습니다. 💦");
        }
    });
}