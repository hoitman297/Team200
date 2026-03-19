$(document).ready(function () {
    /* [1. 공통: 드롭다운 메뉴 제어] */
    const $mainMenu = $('#mainMenu');

    $mainMenu.on('click', function (e) {
        $(this).toggleClass('show');
        e.stopPropagation();
    });

    $(window).on('click', function () {
        if ($mainMenu.hasClass('show')) {
            $mainMenu.removeClass('show');
        }
    });
});

    // 메뉴 바깥쪽 클릭하면 닫기
    $(window).on('click', function() {
        if ($mainMenu.hasClass('show')) {
            $mainMenu.removeClass('show');
        }
    });