window.onload = function() {
            console.log("글쓰기 페이지 로드 완료");
        };

        document.getElementById('writeForm').onsubmit = function(e) {
            e.preventDefault();
            alert('게시글이 성공적으로 등록되었습니다.');
            location.href = 'board-free.html'; 
        };