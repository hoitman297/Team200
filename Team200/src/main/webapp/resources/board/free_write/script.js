$(document).ready(function() {
    // 1. 페이지 로드 완료 시 실행
    console.log("글쓰기 페이지 로드 완료");

    // 2. 폼 제출(submit) 이벤트 처리
    $('#writeForm').on('submit', function(e) {
        // 기본 제출 동작(페이지 새로고침) 방지
        e.preventDefault();
        
        alert('게시글이 성공적으로 등록되었습니다.');
        
        // 페이지 이동
        location.href = 'board-free.html';
    });
});