function uploadProfile(event) {
    const file = event.target.files[0];
    if (!file) return;

    // 1. 화면에 이미지 미리보기 즉시 적용
    const reader = new FileReader();
    reader.onload = function(e) {
        document.getElementById('profilePreview').src = e.target.result;
    };
    reader.readAsDataURL(file);

    // 2. 서버로 파일 전송 (AJAX)
    const formData = new FormData();
    formData.append('uploadImage', file);

    fetch('/member/updateProfile', {
        method: 'POST',
        body: formData
    })
    .then(response => response.text())
    .then(data => {
        if(data === "success") {
            console.log("서버 전송 성공!");
        } else {
            console.log("서버에서 처리가 안 됨");
        }
    })
    .catch(error => {
        console.error('Error:', error);
    });
}