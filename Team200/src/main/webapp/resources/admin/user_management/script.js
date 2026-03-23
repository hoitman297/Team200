// 모든 .btn-delete 버튼에 클릭 이벤트 연결
$('.btn-delete').click(function() {
    return confirm('해당 회원을 정말 삭제하시겠습니까?');
});