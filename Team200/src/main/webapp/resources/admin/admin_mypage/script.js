function msg(text) {
            alert(text + " 페이지로 이동합니다.");
        }

        function logoutConfirm() {
            if(confirm("로그아웃 하시겠습니까?")) {
                alert("성공적으로 로그아웃되었습니다.");
            }
        }

        function changeImage() {
            const input = document.createElement('input');
            input.type = 'file';
            input.accept = 'image/*';
            input.onchange = e => {
                alert('이미지 파일이 선택되었습니다: ' + e.target.files[0].name);
            };
            input.click();
        }