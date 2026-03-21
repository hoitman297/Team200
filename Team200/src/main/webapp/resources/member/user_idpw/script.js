function switchTab(type) {
            // 1. 모든 탭과 섹션의 활성화 클래스 제거
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.find-section').forEach(s => s.classList.remove('active'));

            // 2. 선택한 탭에 따른 화면 전환
            if (type === 'id') {
                document.getElementById('tab-id').classList.add('active');
                document.getElementById('section-id').classList.add('active');
            } else {
                document.getElementById('tab-pw').classList.add('active');
                document.getElementById('section-pw').classList.add('active');
            }
        }