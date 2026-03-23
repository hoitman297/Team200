const fileInput = document.getElementById('fileInput');
        const previewImage = document.getElementById('previewImage');
        const placeholder = document.getElementById('placeholder');
        const dropzone = document.getElementById('dropzone');

        // 파일 선택 시 미리보기 처리
        fileInput.addEventListener('change', function() {
            const file = this.files[0];
            if (file) {
                if (file.type.startsWith('image/')) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        previewImage.src = e.target.result;
                        previewImage.style.display = 'block';
                        placeholder.style.display = 'none';
                        dropzone.style.borderStyle = 'solid';
                    }
                    reader.readAsDataURL(file);
                } 
                else if (file.type.startsWith('video/')) {
                    previewImage.style.display = 'none';
                    placeholder.style.display = 'block';
                    placeholder.innerHTML = "<span>🎬</span><p>" + file.name + "<br>영상이 선택되었습니다.</p>";
                    dropzone.style.borderStyle = 'solid';
                }
            }
        });

        // 폼 제출 시 유효성 검사
        document.getElementById('galleryForm').onsubmit = function(e) {
            if (!fileInput.files.length) {
                e.preventDefault();
                alert('사진이나 영상 파일을 반드시 첨부해야 합니다!');
                return false;
            }
            alert('게시글이 성공적으로 등록되었습니다.');
        };