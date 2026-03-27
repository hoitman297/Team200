$(document).ready(function() {

    // =========================================================================
    // 1. 테이블 페이징 및 필터링 관련 변수
    // =========================================================================
    let currentPage = 0;
    const rowsPerPage = 6; // 아래로 6개씩!
    let visibleRows = [];
    
    // ✨ [추가] 현재 선택된 카테고리 태그들을 기억하는 변수
    let currentSearchTags = 'all'; 
    let activeCategory = ""; 

    // 화면에 6개씩 끊어서 보여주는 함수
    function updateTablePaging() {
        const start = currentPage * rowsPerPage;
        const end = start + rowsPerPage;

        // 모든 행을 숨기고 현재 페이지 범위만 표시
        $('.item-row').hide();
        visibleRows.slice(start, end).forEach(row => $(row).show());

        // UI 업데이트 (페이지 번호 및 버튼 활성화 상태)
        const totalPages = Math.ceil(visibleRows.length / rowsPerPage) || 1;
        $('#currentPage').text(currentPage + 1);
        $('#totalPage').text(totalPages);
        
        $('#prevBtn').prop('disabled', currentPage === 0);
        $('#nextBtn').prop('disabled', end >= visibleRows.length);
    }

    // ✨ [핵심 수정] 검색어와 카테고리를 "동시에" 검사하는 통합 필터 함수 ✨
    function applyCombinedFilters() {
        // 1. 현재 검색창에 적힌 글자 가져오기
        const searchTerm = $('#itemSearchInput').val().toLowerCase();
        visibleRows = []; // 보여줄 목록 초기화

        // 2. 모든 아이템을 하나씩 검사
        $('.item-row').each(function() {
            const itemTags = $(this).data('tags') || ""; 
            const itemName = ($(this).data('name') || "").toLowerCase();

            // 조건 A: 카테고리가 맞거나 전체보기 상태인가?
            let isCategoryMatch = (currentSearchTags === 'all') || currentSearchTags.some(t => itemTags.includes(t));
            
            // 조건 B: 검색어가 이름에 포함되어 있는가?
            let isSearchMatch = itemName.includes(searchTerm);

            // 두 조건을 모두 만족해야만 화면에 표시할 목록(visibleRows)에 추가!
            if (isCategoryMatch && isSearchMatch) {
                visibleRows.push(this);
            }
        });

        // 필터링이 끝났으니 무조건 1페이지(인덱스 0)로 돌려놓고 화면 갱신
        currentPage = 0;
        updateTablePaging();
    }

    // =========================================================================
    // 2. 이벤트 리스너 (카테고리 클릭, 검색창 입력, 이전/다음 버튼)
    // =========================================================================

    // 카테고리 버튼 클릭 이벤트
    $('.category-btn').on('click', function() {
        const $this = $(this);
        const categoryName = $this.find('span').text().trim();
        
        $('.category-btn').removeClass('active').css('opacity', '0.4');

        // 이미 켜진 버튼을 다시 누르면 '전체 보기'로 해제
        if (activeCategory === categoryName) {
            activeCategory = ""; 
            $('.category-btn').css('opacity', '1'); 
            currentSearchTags = 'all'; // 태그 초기화
            applyCombinedFilters(); // 필터 재적용
            return; 
        }

        // 새로운 버튼 클릭 시
        activeCategory = categoryName; 
        $this.addClass('active').css('opacity', '1'); 

        // 카테고리에 맞는 검색 태그 설정
        switch(categoryName) {
            case "전사": currentSearchTags = ["Damage", "Health"]; break;
            case "원거리 딜러": currentSearchTags = ["AttackSpeed", "CriticalStrike"]; break;
            case "암살자": currentSearchTags = ["ArmorPenetration", "Damage"]; break;
            case "마법사": currentSearchTags = ["SpellDamage"]; break;
            case "탱커": currentSearchTags = ["Armor", "SpellBlock", "Health"]; break;
            case "서포터": currentSearchTags = ["ManaRegen", "Vision", "Active"]; break;
        }
        
        applyCombinedFilters(); // 필터 재적용
    });

    // 검색창 입력 이벤트 (글자를 칠 때마다 즉시 적용)
    $('#itemSearchInput').on('input', function() {
        applyCombinedFilters();
    });

    // 이전/다음 버튼 이벤트
    $('#nextBtn').on('click', function() {
        currentPage++;
        updateTablePaging();
    });

    $('#prevBtn').on('click', function() {
        currentPage--;
        updateTablePaging();
    });

    // 페이지가 처음 로딩될 때 전체 목록을 6개씩 잘라서 보여주기
    applyCombinedFilters();

    // =========================================================================
    // 3. 아이템 설명 마우스 툴팁 (기존 코드 유지)
    // =========================================================================
    const $tooltip = $('#item-tooltip');

    $('.item-row').on({
        'mouseenter': function(e) {
            let itemInfo = $(this).data('info');
            if(itemInfo && itemInfo.trim() !== '') {
                $tooltip.html(itemInfo).show();
            }
        },
        'mousemove': function(e) {
            $tooltip.css({
                'left': (e.pageX + 15) + 'px',
                'top': (e.pageY + 15) + 'px'
            });
        },
        'mouseleave': function() {
            $tooltip.hide().html('');
        }
    });

    $('.item-row').css('cursor', 'pointer');

    // =========================================================================
    // 4. 룬 (특성) 로딩 기능 (기존 코드 유지)
    // =========================================================================
    if ($(".path-icon").length > 0) {
        $(".path-icon").first().click();
    }
});

// 전역 함수 (기존 코드 유지)
function loadTalents(runeNo, runeName, element) {
    $(".path-icon").removeClass("active");
    $(element).addClass("active");
    $("#primary-path-name").text("핵심 빌드: " + runeName);
    
    let requestUrl = contextPath + "/lol/runes/talents";
    $.ajax({
        url: requestUrl,
        type: "GET",
        data: { runeNo: runeNo },
        success: function(data) {
            if(data && data.length > 0) {
                let mainRunesHtml = `<div class="keystone-row">`;
                let subRunesHtml  = `<div class="subrune-grid">`;
                let mainRuneCount = (runeName === '정밀') ? 4 : 3;
                data.forEach((t, index) => {
                    let isMainRune = (index < mainRuneCount); 
                    let slotClass = isMainRune ? "main-rune" : "sub-rune";
                    let slotHtml = `<div class="talent-slot ${slotClass}" onclick="showDetail(this, '${t.talentName}', '${t.talentImg}', '${t.talentInfo}')">
                                        <img src="${t.talentImg}" alt="${t.talentName}">
                                    </div>`;
                    if (isMainRune) mainRunesHtml += slotHtml;
                    else subRunesHtml += slotHtml;
                });
                mainRunesHtml += `</div>`;
                subRunesHtml += `</div>`;
                $("#primary-slots-container").html(mainRunesHtml + subRunesHtml);
                setTimeout(() => { $(".talent-slot").first().click(); }, 100);
            } else {
                $("#primary-slots-container").html("<p style='color:white;'>데이터가 없습니다.</p>");
            }
        },
        error: function(xhr, status, error) { console.error("에러 발생: ", error); }
    });
}

function showDetail(element, name, imgUrl, info) {
    $(".talent-slot").removeClass("active");
    $(element).addClass("active");
    $("#desc-name").html(`<img src="${imgUrl}"> ${name}`);
    $("#desc-text").html(info);
}