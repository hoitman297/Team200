function changeImage() {
            const input = document.createElement('input');
            input.type = 'file';
            input.accept = 'image/*';
            input.onchange = e => {
                alert('이미지 파일이 선택되었습니다: ' + e.target.files[0].name);
            };
            input.click();
        }