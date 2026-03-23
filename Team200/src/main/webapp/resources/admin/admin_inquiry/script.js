function toggleReply(id) {
    const $replyRow = $(`#reply-${id}`);
    
    // 다른 열려있는 창을 닫고 싶다면 아래 주석 해제
    // $('[id^="reply-"]').hide();
    
    // 현재 요소의 표시 상태를 확인하여 토글
    if ($replyRow.is(':hidden')) {
        $replyRow.show(); // 기본적으로 table-row 상태로 보여줍니다.
    } else {
        $replyRow.hide();
    }
}