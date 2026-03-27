$(function() {
    console.log("✅ [LOG.GG] 검색/필터링 시스템 가동!");

    // 게시판 필터링
    $(document).on("input keyup", "#boardSearchInput", function() {
        let val = $(this).val().toLowerCase().trim();
        $("#boardTableBody .board-row-item").each(function() {
            let text = $(this).find(".td-title").text().toLowerCase();
            $(this).toggle(text.indexOf(val) > -1);
        });
    });

    // 영웅/챔피언 필터링
    $(document).on("input keyup", "#heroSearchInput, .search-input-field", function() {
        let searchValue = $(this).val().toLowerCase().trim();
        let $items = $(".hero-item"); // JSP에서 넣은 클래스 타겟팅
        
        if ($items.length > 0) {
            $items.each(function() {
                let itemName = $(this).find(".hero-name").text().toLowerCase();
                
                if (itemName.indexOf(searchValue) > -1) {
                    // 필터링 시 display 속성이 꼬이지 않게 처리
                    $(this).attr('style', 'display: flex !important'); 
                } else {
                    $(this).attr('style', 'display: none !important');
                }
            });
        }
    });
    
        // ✨ 3. [신규] 롤 아이템 실시간 필터링 ✨
    $(document).on("input keyup", "#itemSearchInput", function() {
        let searchValue = $(this).val().toLowerCase().trim();
        
        $("#itemTableBody .item-row").each(function() {
            // 이름(.item-name-cell)과 태그(data-tags) 추출
            let itemName = $(this).find(".item-name-cell").text().toLowerCase();
            let itemTags = $(this).attr("data-tags") ? $(this).attr("data-tags").toLowerCase() : "";
            
            // 검색어가 이름이나 태그에 포함되면 표시!
            if (itemName.indexOf(searchValue) > -1 || itemTags.indexOf(searchValue) > -1) {
                $(this).show();
            } else {
                $(this).hide();
            }
        });
    });

    // ✨ 4. [보너스] 카테고리 버튼 클릭 시 자동 검색 ✨
    $(document).on("click", ".category-btn", function() {
        let categoryName = $(this).find("span").text().trim();
        // 검색창에 카테고리명을 넣고 강제로 keyup 이벤트를 발생시켜서 필터링!
        $("#itemSearchInput").val().trigger("keyup");
    });
});
