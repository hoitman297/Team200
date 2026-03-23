$(document).ready(function() {
    const $fileInput = $('#fileInput');
    const $previewImage = $('#previewImage');
    const $placeholder = $('#placeholder');
    const $dropzone = $('#dropzone');

    // 1. 파일 선택 시 미리보기 처리
    $fileInput.on('change', function() {
        const file = this.files[0]; // 파일 객체는 기존 방식대로 가져옵니다.

        if (file) {
            // 이미지 파일인 경우
            if (file.type.startsWith('image/')) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    $previewImage.attr('src', e.target.result).show(); // 주소 넣고 바로 보이기
                    $placeholder.hide(); // 가이드 문구 숨기기
                    $dropzone.css('border-style', 'solid'); // 테두리 변경
                }
                reader.readAsDataURL(file);
            } 
            // 영상 파일인 경우
            else if (file.type.startsWith('video/')) {
                $previewImage.hide();
                $placeholder.show().html(`<span>🎬</span><p>${file.name}<br>영상이 선택되었습니다.</p>`);
                $dropzone.css('border-style', 'solid');
            }
        }
    });

    // 2. 폼 제출 시 유효성 검사
    $('#galleryForm').on('submit', function(e) {
        // 파일이 선택되지 않았는지 확인 (files.length가 0이면 선택 안 됨)
        if (!$fileInput[0].files.length) {
            e.preventDefault();
            alert('사진이나 영상 파일을 반드시 첨부해야 합니다!');
            return false;
        }
        alert('게시글이 성공적으로 등록되었습니다.');
    });
});