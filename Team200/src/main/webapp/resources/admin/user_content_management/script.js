// 탭 전환 기능
        function switchTab(element, type) {
            document.querySelectorAll('.tab-item').forEach(item => item.classList.remove('active'));
            element.classList.add('active');

            const body = document.getElementById('admin-list-body');
            
            if(type === 'comment') {
                body.innerHTML = `
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
                `;
            } else {
                // 게시물 관리 탭 클릭 시 (예시 데이터)
                body.innerHTML = `
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
                `;
            }
        }

        // 삭제 확인 기능
        function deleteItem(btn) {
            const row = btn.closest('tr');
            const content = row.querySelector('.text-left').innerText;
            if(confirm(`"${content}"\n해당 항목을 정말로 삭제하시겠습니까?`)) {
                row.style.opacity = '0.3';
                row.style.pointerEvents = 'none';
                alert('삭제 처리가 완료되었습니다.');
            }
        }