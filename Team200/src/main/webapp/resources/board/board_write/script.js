window.onload = function() {
            console.log("글쓰기 페이지 로드 완료");
        };

        document.getElementById('writeForm').onsubmit = function(e) {
            e.preventDefault();
            alert('게시글이 성공적으로 등록되었습니다.');
            location.href = 'board-free.html'; 
        };
        
// 모든 AJAX 요청에 CSRF 토큰을 자동으로 포함시키는 설정
$(function() {
    var token = $("meta[name='_csrf']").attr("content");
    var header = $("meta[name='_csrf_header']").attr("content");
    
    $(document).ajaxSend(function(e, xhr, options) {
        if (token && header) {
            xhr.setRequestHeader(header, token);
        }
    });
});