$(document).ready(function() {
    // 1. 페이지 로드 완료 시 실행 (window.onload 대체)
    console.log("글쓰기 페이지 로드 완료");

    // 2. 폼 제출(submit) 이벤트 처리 (document.getElementById... 대체)
    $('#writeForm').on('submit', function(e) {
        // 기본 제출 동작(페이지 새로고침) 방지
        e.preventDefault();
        
        alert('게시글이 성공적으로 등록되었습니다.');
        
        // 페이지 이동 (자바스크립트 표준 방식 유지)
        location.href = 'board-free.html';
    });
});