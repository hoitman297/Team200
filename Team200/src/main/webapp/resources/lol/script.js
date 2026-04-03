$(document).ready(function() {
    // =========================================================================
    // 1. 테이블 페이징 및 필터링 관련 변수
    // =========================================================================
    let currentPage = 0;
    const rowsPerPage = 6; 
    let visibleRows = [];
    
    let currentSearchTags = 'all'; 
    let activeCategory = ""; 

    function updateTablePaging() {
        const start = currentPage * rowsPerPage;
        const end = start + rowsPerPage;

        $('.item-row').hide();
        visibleRows.slice(start, end).forEach(row => $(row).show());

        const totalPages = Math.ceil(visibleRows.length / rowsPerPage) || 1;
        $('#currentPage').text(currentPage + 1);
        $('#totalPage').text(totalPages);
        
        $('#prevBtn').prop('disabled', currentPage === 0);
        $('#nextBtn').prop('disabled', end >= visibleRows.length);
    }

    function applyCombinedFilters() {
        const searchTerm = $('#itemSearchInput').val().toLowerCase();
        visibleRows = []; 

        $('.item-row').each(function() {
            const itemTags = $(this).data('tags') || ""; 
            const itemName = ($(this).data('name') || "").toLowerCase();

            // 조건 A: 태그 필터 ('all'이면 모두 통과)
            let isCategoryMatch = (currentSearchTags === 'all') || currentSearchTags.some(t => itemTags.includes(t));
            // 조건 B: 검색어 필터
            let isSearchMatch = itemName.includes(searchTerm);

            if (isCategoryMatch && isSearchMatch) {
                visibleRows.push(this);
            }
        });

        // 필터링된 배열(visibleRows)을 가지고 페이징 처리를 수행
        currentPage = 0;
        updateTablePaging();
    }

    // =========================================================================
    // 2. 이벤트 리스너 (카테고리 클릭, 검색창 입력, 이전/다음 버튼)
    // =========================================================================
    
    // ✨ 핵심: 이벤트 객체(e)를 받아옵니다.
    $('.category-btn').on('click', function(e) {
        
        // ✨ [방어 로직 1] 클릭 이벤트가 search/script.js 등으로 퍼져나가는 것을 완벽 차단!
        e.stopPropagation(); 
        
        const $this = $(this);
        const categoryName = $this.find('span').text().trim();
        
        $('.category-btn').removeClass('active').css('opacity', '0.4');

        // 이미 선택된 카테고리를 다시 누른 경우 -> '전체보기'로 전환
        if (activeCategory === categoryName) {
            activeCategory = ""; 
            $('.category-btn').css('opacity', '1'); 
            currentSearchTags = 'all'; 
            
            // ✨ [방어 로직 2] 카테고리 해제 시 검색창 초기화
            $('#itemSearchInput').val(''); 
            
            applyCombinedFilters(); 
            return; 
        }

        // 새로운 카테고리 선택 시
        activeCategory = categoryName; 
        $this.addClass('active').css('opacity', '1'); 

        switch(categoryName) {
            case "전사": currentSearchTags = ["Damage", "Health"]; break;
            case "원거리 딜러": currentSearchTags = ["AttackSpeed", "CriticalStrike"]; break;
            case "암살자": currentSearchTags = ["ArmorPenetration", "Damage"]; break;
            case "마법사": currentSearchTags = ["SpellDamage"]; break;
            case "탱커": currentSearchTags = ["Armor", "SpellBlock", "Health"]; break;
            case "서포터": currentSearchTags = ["ManaRegen", "Vision", "Active"]; break;
        }
        
        // ✨ [방어 로직 3] 다른 스크립트가 값을 억지로 밀어넣었을 만일의 사태를 대비해 
        // 카테고리 이동 시 검색창을 항상 깨끗하게 지워줍니다.
        $('#itemSearchInput').val('');
        
        applyCombinedFilters(); 
    });

    $('#itemSearchInput').on('input', function() {
        applyCombinedFilters();
    });

    $('#nextBtn').on('click', function() {
        currentPage++;
        updateTablePaging();
    });

    $('#prevBtn').on('click', function() {
        currentPage--;
        updateTablePaging();
    });

    // 첫 로드 시 '모두보기' 상태로 페이징 적용
    applyCombinedFilters(); 

    // =========================================================================
    // 3. 아이템 설명 마우스 툴팁 
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
    // 4. 룬 (특성) 로딩 기능
    // =========================================================================
    if ($(".path-icon").length > 0) {
        $(".path-icon").first().click();
    }
});

// 전역 함수 
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
                
                let firstSlot = $(".talent-slot").first();
                if(firstSlot.length > 0) {
                    firstSlot[0].click(); 
                }
            } else {
                $("#primary-slots-container").html("<p style='color:#94a3b8; text-align:center;'>데이터가 없습니다.</p>");
                $("#desc-name").html("룬 정보 없음");
                $("#desc-text").html("선택된 룬 경로에 데이터가 존재하지 않습니다.");
            }
        },
        error: function(xhr, status, error) { 
            console.error("에러 발생: ", error); 
        }
    });
}

function showDetail(element, name, imgUrl, info) {
    $(".talent-slot").removeClass("active");
    $(element).addClass("active");
    $("#desc-name").html(`<img src="${imgUrl}"> ${name}`);
    $("#desc-text").html(info);
}