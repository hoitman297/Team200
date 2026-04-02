$(function() {
    console.log("✅ [LOG.GG] 검색/필터링 시스템 가동!");

    // ❌ [수정됨] 1. 게시판 실시간 필터링 제거 (주석 처리)
    // 이유: 게시판 검색은 이제 form 태그를 통해 서버(DB)로 파라미터를 넘겨 전체 페이지를 조회하는 방식으로 변경됨.
    /*
    $(document).on("input keyup", "#boardSearchInput", function() {
        let val = $(this).val().toLowerCase().trim();
        $("#boardTableBody .board-row-item").each(function() {
            let text = $(this).find(".td-title").text().toLowerCase();
            $(this).toggle(text.indexOf(val) > -1);
        });
    });
    */

    // ✨ 2. 영웅/챔피언 필터링 (기존 클라이언트 사이드 유지)
    // 수정 포인트: 게시판 검색창과 충돌하지 않도록 ".search-input-field" 클래스는 빼고 ID("#heroSearchInput")만 타겟팅합니다.
    $(document).on("input keyup", "#heroSearchInput", function() {
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
    
    // ✨ 3. [신규] 롤 아이템 실시간 필터링 ✨ (기존 클라이언트 사이드 유지)
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
        // 수정 포인트: val() 안에 categoryName을 넣어줘야 검색창에 글자가 들어가면서 검색이 실행됩니다!
        $("#itemSearchInput").val(categoryName).trigger("keyup");
    });
});