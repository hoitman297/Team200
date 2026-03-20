function msg(text) {
    // 템플릿 리터럴(` `)을 사용하면 더 직관적입니다.
    alert(`${text} 페이지로 이동합니다.`);
}

function logoutConfirm() {
    // confirm 창의 로직은 자바스크립트와 동일하게 유지됩니다.
    if (confirm("로그아웃 하시겠습니까?")) {
        alert("성공적으로 로그아웃되었습니다.");
    }
}

function changeImage() {
    // 1. input 요소를 jQuery 방식으로 생성
    const $input = $('<input>', {
        type: 'file',
        accept: 'image/*'
    });

    // 2. 파일이 선택되었을 때(change)의 동작 정의
    $input.on('change', function(e) {
        const fileName = e.target.files[0].name;
        alert(`이미지 파일이 선택되었습니다: ${fileName}`);
    });

    // 3. 생성된 input을 클릭하여 파일 탐색기 열기
    $input.click();
}