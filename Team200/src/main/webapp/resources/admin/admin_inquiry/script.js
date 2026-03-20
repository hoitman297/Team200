function toggleReply(id) {
            const replyRow = document.getElementById(`reply-${id}`);
            const isHidden = replyRow.style.display === 'none';
            
            // 다른 열려있는 창을 닫고 싶다면 아래 주석 해제
            // document.querySelectorAll('[id^="reply-"]').forEach(el => el.style.display = 'none');
            
            replyRow.style.display = isHidden ? 'table-row' : 'none';
        }