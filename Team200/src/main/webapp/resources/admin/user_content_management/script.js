// 탭 전환 기능
function switchTab(element, type) {
    // 1. 탭 활성화 변경: 모든 .tab-item에서 active 제거 후 클릭한 요소에 추가
    $('.tab-item').removeClass('active');
    $(element).addClass('active');

    const $body = $('#admin-list-body');
    
    // 2. 타입에 따라 HTML 내용 교체
    if(type === 'comment') {
        $body.html(`
            <tr>
                <td>45</td>
                <td><span style="color:#3b82f6; font-weight:700;">배틀그라운드</span></td>
                <td class="text-left">오 정보 감사합니다! 오늘 가볼게요.</td>
                <td><span class="author-tag">Gamer_A</span></td>
                <td>03.10</td>
                <td><button class="btn-delete" onclick="deleteItem(this)">삭제</button></td>
            </tr>
            <tr>
                <td>44</td>
                <td><span style="color:#ef4444; font-weight:700;">오버워치</span></td>
                <td class="text-left">동의합니다 딜러 너무 세졌어요 ㅠㅠ</td>
                <td><span class="author-tag">Healer_Main</span></td>
                <td>03.10</td>
                <td><button class="btn-delete" onclick="deleteItem(this)">삭제</button></td>
            </tr>
        `);
    } else {
        // 게시물 관리 탭 클릭 시
        $body.html(`
            <tr>
                <td>124</td>
                <td><span style="color:#3b82f6; font-weight:700;">배틀그라운드</span></td>
                <td class="text-left">에란겔 짤파밍 꿀팁 공유합니다.</td>
                <td><span class="author-tag">USER01</span></td>
                <td>03.09</td>
                <td><button class="btn-delete" onclick="deleteItem(this)">삭제</button></td>
            </tr>
            <tr>
                <td>123</td>
                <td><span style="color:#ef4444; font-weight:700;">오버워치</span></td>
                <td class="text-left">이번 패치 딜러 버프 체감 되나요?</td>
                <td><span class="author-tag">Kim_Log</span></td>
                <td>03.08</td>
                <td><button class="btn-delete" onclick="deleteItem(this)">삭제</button></td>
            </tr>
        `);
    }
}

// 삭제 확인 기능
function deleteItem(btn) {
    // btn(현재 클릭된 버튼)을 기준으로 가장 가까운 tr(행)을 찾음
    const $row = $(btn).closest('tr');
    
    // 해당 행 내부의 .text-left 클래스를 가진 요소의 텍스트를 가져옴
    const content = $row.find('.text-left').text();
    
    if(confirm(`"${content}"\n해당 항목을 정말로 삭제하시겠습니까?`)) {
        // CSS 속성을 여러 개 바꿀 때 .css({ }) 객체 형식을 사용하면 편리함
        $row.css({
            'opacity': '0.3',
            'pointer-events': 'none'
        });
        alert('삭제 처리가 완료되었습니다.');
    }
}