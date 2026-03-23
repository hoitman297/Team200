// 간단한 버튼 액션 스크립트
        document.querySelectorAll('.btn-delete').forEach(btn => {
            btn.onclick = () => confirm('해당 회원을 정말 삭제하시겠습니까?');
        });