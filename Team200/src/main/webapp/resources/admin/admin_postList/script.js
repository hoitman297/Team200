function switchTab(element, type) {
    // 1. 모든 .tab-item에서 active 클래스를 제거하고, 클릭된 요소에만 추가
    $('.tab-item').removeClass('active');
    $(element).addClass('active');

    // 2. 리스트 바디(list-body) 요소 선택
    const $body = $('#list-body');

    // 3. 타입에 따른 데이터 처리
    if (type === 'patch') {
        // .html() 함수를 사용하여 테이블 내부 내용을 변경
        $body.html(`
            <tr>
                <td>002</td>
                <td class="title-link">[패치] v1.4.2 밸런스 조정 및 버그 수정</td>
                <td>25-03-05</td>
                <td>8,921</td>
                <td>
                    <button class="btn-action">수정</button> 
                    <button class="btn-action btn-delete">삭제</button>
                </td>
            </tr>
            <tr>
                <td>001</td>
                <td class="title-link">[패치] 배틀그라운드 신규 맵 업데이트 소식</td>
                <td>25-02-15</td>
                <td>12,400</td>
                <td>
                    <button class="btn-action">수정</button> 
                    <button class="btn-action btn-delete">삭제</button>
                </td>
            </tr>
        `);
    } else {
        // 공지사항 등 다른 타입일 경우 페이지 새로고침 (기존 로직 유지)
        location.reload();
    }
}