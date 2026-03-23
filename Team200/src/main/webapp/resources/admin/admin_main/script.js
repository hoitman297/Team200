function openTab(evt, tabName) {
    // 1. 모든 탭 내용(.tab-pane)을 숨기고 active 클래스 제거
    $(".tab-pane").hide().removeClass("active");

    // 2. 모든 탭 버튼(.tab-btn)에서 active 클래스 제거
    $(".tab-btn").removeClass("active");

    // 3. 선택된 탭 내용(#tabName)만 보여주고 active 클래스 추가
    $(`#${tabName}`).show().addClass("active");

    // 4. 클릭된 버튼(evt.currentTarget)에 active 클래스 추가
    $(evt.currentTarget).addClass("active");
}