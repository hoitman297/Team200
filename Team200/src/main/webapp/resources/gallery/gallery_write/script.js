document.addEventListener('DOMContentLoaded', function() {
    const fileInput = document.getElementById('fileInput');
    const previewImage = document.getElementById('previewImage');
    const placeholder = document.getElementById('placeholder');
    const dropzone = document.getElementById('dropzone');
    const galleryForm = document.getElementById('galleryForm');

    // 1. 파일 선택 시 미리보기 처리
    fileInput.addEventListener('change', function() {
        const file = this.files[0];
        
        if (file) {
            // 이미지 파일
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
            // 영상 파일
            else if (file.type.startsWith('video/')) {
                previewImage.style.display = 'none';
                placeholder.style.display = 'block';
                placeholder.innerHTML = "<span>🎬</span><p style='color:var(--point-green); font-weight:bold; margin-top:10px;'>" + file.name + "</p><small>영상이 선택되었습니다.</small>";
                dropzone.style.borderStyle = 'solid';
            }
        } else {
            // 파일 선택을 취소했을 때 원상복구
            previewImage.src = '';
            previewImage.style.display = 'none';
            placeholder.style.display = 'block';
            placeholder.innerHTML = "<span>📷</span><p>클릭하여 사진이나 영상을 첨부하세요<br><small>(파일이 없으면 등록할 수 없습니다)</small></p>";
            dropzone.style.borderStyle = 'dashed';
        }
    });

    // 2. 드래그 앤 드롭 처리 (편의성 UP!)
    dropzone.addEventListener('dragover', function(e) {
        e.preventDefault();
        dropzone.style.borderColor = 'var(--point-green)';
        dropzone.style.backgroundColor = '#f1f3f5';
    });

    dropzone.addEventListener('dragleave', function(e) {
        e.preventDefault();
        dropzone.style.borderColor = 'var(--primary-navy)';
        dropzone.style.backgroundColor = 'var(--bg-soft)';
    });

    dropzone.addEventListener('drop', function(e) {
        e.preventDefault();
        dropzone.style.borderColor = 'var(--primary-navy)';
        dropzone.style.backgroundColor = 'var(--bg-soft)';
        
        if (e.dataTransfer.files.length > 0) {
            fileInput.files = e.dataTransfer.files;
            // 파일이 추가되었음을 알리고 미리보기 실행
            fileInput.dispatchEvent(new Event('change'));
        }
    });

    // 3. 폼 제출 시 유효성 검사
    if (galleryForm) {
        galleryForm.onsubmit = function(e) {
            // fileInput에 required 속성이 있는 경우(새 글 작성)에만 파일 검사
            if (fileInput.hasAttribute('required') && !fileInput.files.length) {
                e.preventDefault();
                alert('사진이나 영상 파일을 반드시 첨부해야 합니다!');
                return false;
            }
            
            // 폼 전송 성공 시
            // (서버에서 성공 여부를 처리하는 경우 alert는 방해될 수 있으니 필요에 따라 주석 처리하셔도 좋습니다!)
            // alert('게시글 등록 처리를 시작합니다.'); 
        };
    }
});