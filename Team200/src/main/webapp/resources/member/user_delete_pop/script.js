document.addEventListener('DOMContentLoaded', function() {
    const checkbox = document.getElementById('withdrawCheck');
    const submitBtn = document.getElementById('submitBtn');

    // 요소가 정상적으로 로드되었는지 확인
    if (!checkbox || !submitBtn) return;

    // 초기 상태 설정 (페이지 로드 시 체크 안 되어 있으면 버튼 비활성화)
    if (!checkbox.checked) {
        submitBtn.disabled = true;
        submitBtn.classList.remove('active');
    }

    checkbox.addEventListener('change', function() {
        if (this.checked) {
            submitBtn.classList.add('active');
            submitBtn.disabled = false;
        } else {
            submitBtn.classList.remove('active');
            submitBtn.disabled = true;
        }
    });

    submitBtn.addEventListener('click', function() {
        // 활성화 상태(빨간 버튼)일 때만 동작
        if (this.classList.contains('active') && !this.disabled) {
            const deleteUrl = this.getAttribute('data-url');
            
            // 지정된 URL로 이동
            if(deleteUrl) {
                location.href = deleteUrl;
            }
        }
    });
});