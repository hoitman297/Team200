function sendCode() {
            alert('입력하신 이메일로 인증번호가 발송되었습니다.');
        }

        document.getElementById('withdrawalAuthForm').addEventListener('submit', function(e) {
            e.preventDefault();
            if (confirm('모든 정보가 확인되었습니다. 정말로 탈퇴하시겠습니까?')) {
                alert('탈퇴 처리가 완료되었습니다. 그동안 이용해주셔서 감사합니다.');
                window.location.href = 'main.html'; 
            }
        });