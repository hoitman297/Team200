function switchTab(element, type) {
            // 탭 활성화 변경
            document.querySelectorAll('.tab-item').forEach(item => item.classList.remove('active'));
            element.classList.add('active');

            // 실제 구현 시에는 여기서 API를 호출해 데이터를 바꿔줍니다.
            const body = document.getElementById('list-body');
            if(type === 'patch') {
                body.innerHTML = `
                    <tr>
                        <td>002</td>
                        <td class="title-link">[패치] v1.4.2 밸런스 조정 및 버그 수정</td>
                        <td>25-03-05</td>
                        <td>8,921</td>
                        <td><button class="btn-action">수정</button> <button class="btn-action btn-delete">삭제</button></td>
                    </tr>
                    <tr>
                        <td>001</td>
                        <td class="title-link">[패치] 배틀그라운드 신규 맵 업데이트 소식</td>
                        <td>25-02-15</td>
                        <td>12,400</td>
                        <td><button class="btn-action">수정</button> <button class="btn-action btn-delete">삭제</button></td>
                    </tr>
                `;
            } else {
                location.reload(); // 공지사항으로 복구 (예시)
            }
        }