$(document).ready(function () {
    console.log("✅ [메인] 스크립트 로드 완료!");

    /* [1. 공통: 드롭다운 메뉴 제어] */
    const $mainMenu = $('#mainMenu');

    // 메뉴 클릭 시 토글
    if ($mainMenu.length) { // mainMenu가 페이지에 있을 때만 작동
        $mainMenu.on('click', function (e) {
            $(this).toggleClass('show');
            e.stopPropagation();
        });

        // 메뉴 바깥쪽 클릭하면 닫기 (이걸 안으로 넣어야 에러가 안 나!)
        $(window).on('click', function () {
            if ($mainMenu.hasClass('show')) {
                $mainMenu.removeClass('show');
            }
        });
    }
});