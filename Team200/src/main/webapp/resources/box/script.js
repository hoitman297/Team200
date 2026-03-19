$(document).ready(function () {
    /* [3. 상자 시뮬레이션 로직] */
    // 데이터 관리 객체
    let gachaData = { total: 0, s: 0, a: 0, b: 0 };

    // 뽑기 함수를 전역(window)에 할당하여 HTML의 onclick에서 접근 가능하게 함
    window.gacha = function (count) {
        let lastItem = "";
        const $display = $('#display');

        for (let i = 0; i < count; i++) {
            gachaData.total++;
            let rand = Math.random() * 100;

            if (rand < 2) {
                gachaData.s++;
                lastItem = "✨ S등급 획득! ✨";
            } else if (rand < 15) {
                gachaData.a++;
                lastItem = "💎 A등급 획득";
            } else {
                gachaData.b++;
                lastItem = "📦 B등급 획득";
            }
        }

        if (count === 1) {
            $display.text(lastItem);
            $display.css('color', lastItem.includes("S등급") ? "#f59e0b" : "#475569");
        } else {
            $display.text("10회 연속 뽑기 완료!");
            $display.css('color', "#475569");
        }
        updateUI();
    };

    // UI 업데이트 함수
    function updateUI() {
        $('#total').text(gachaData.total);
        $('#s-count').text(gachaData.s);
        $('#a-count').text(gachaData.a);
        $('#b-count').text(gachaData.b);
    }

    // 초기화 함수
    window.resetStats = function () {
        gachaData = { total: 0, s: 0, a: 0, b: 0 };
        $('#display').text("초기화되었습니다.");
        updateUI();
    };
});