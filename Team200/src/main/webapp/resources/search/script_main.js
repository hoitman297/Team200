$(function() {
    const $searchInput = $("#globalSearchInput");
    const $searchResults = $("#searchResults");
    
    // 1. 현재 페이지의 게임 정보 파악
    // 메인페이지라면 data-current-game이 없거나 "all"이겠죠?
    const currentGame = $searchResults.data("current-game"); 

    $searchInput.on("input focus", function() {
        const keyword = $(this).val().toLowerCase().trim();

        if (keyword !== "") {
            $searchResults.show();

            $(".search-item").each(function() {
                const $item = $(this);
                const itemText = $item.text().toLowerCase();
                const itemGame = $item.data("game"); // 아이템 자체의 게임 정보

                // ✨ 필터링 조건
                // 조건 A: 키워드가 텍스트에 포함되어야 함
                const isMatchKeyword = itemText.includes(keyword);
                
                // 조건 B: 현재 페이지가 '전체 메인'이거나, 아이템의 게임이 현재 페이지 게임과 일치해야 함
                // currentGame이 없거나 "all"이면 모든 게임 검색 허용
                const isCorrectGame = (!currentGame || currentGame === "all" || itemGame === currentGame);

                if (isMatchKeyword && isCorrectGame) {
                    $item.show();
                } else {
                    $item.hide();
                }
            });
            
            // 💡 [추가 팁] 모든 항목이 hide 상태라면 "결과 없음"을 보여주는 로직을 넣기 좋아요!
        } else {
            $searchResults.hide();
        }
    });

    // 2. 영역 밖 클릭 시 닫기 (공통)
    $(document).on("click", function(e) {
        if (!$(e.target).closest(".search-bar").length) {
            $searchResults.hide();
        }
    });
});