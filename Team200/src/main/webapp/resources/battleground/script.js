$(document).ready(function() {
    // =========================================================================
    // 1. 배그 아이템 페이징 및 필터링 (새로고침 없는 즉각 반응형)
    // =========================================================================
    let currentPage = 0;
    const rowsPerPage = 8; 
    let visibleRows = [];
    let activeCategory = ""; // 현재 선택된 카테고리 기억

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

    // ✨ 카테고리 + 검색어 통합 필터 함수 ✨
    function applyCombinedFilters() {
        const searchTerm = $('#itemSearchInput').val().toLowerCase();
        visibleRows = []; 

        $('.item-row').each(function() {
            // JSP에서 세팅해둔 data 속성 가져오기
            const itemType = ($(this).data('type') || "").toLowerCase(); 
            const itemName = ($(this).data('name') || "").toLowerCase();

            // 1. 카테고리 일치 여부 (선택 안됐으면 무조건 통과)
            let isCategoryMatch = (activeCategory === "") || itemType.includes(activeCategory.toLowerCase());
            
            // 2. 검색어 일치 여부
            let isSearchMatch = itemName.includes(searchTerm);

            // 두 조건 모두 만족 시 화면에 표시할 목록에 추가
            if (isCategoryMatch && isSearchMatch) {
                visibleRows.push(this);
            }
        });

        currentPage = 0;
        updateTablePaging();
    }

    // =========================================================================
    // 2. 이벤트 리스너 (카테고리 클릭, 검색창, 이전/다음 버튼)
    // =========================================================================
    
    // 카테고리 버튼 클릭 이벤트
    $('.category-btn').on('click', function(e) {
        e.stopPropagation(); // 다른 스크립트와의 충돌 차단
        
        const $this = $(this);
        const categoryName = $this.find('span').text().trim();
        
        $('.category-btn').removeClass('active');

        // 이미 켜진 버튼을 또 누름 -> 해제(모두보기)로 전환
        if (activeCategory === categoryName) {
            activeCategory = ""; 
            $('#itemSearchInput').val(''); // 검색어 초기화
            applyCombinedFilters(); 
            return; 
        }

        // 새로운 카테고리 선택 시
        activeCategory = categoryName; 
        $this.addClass('active'); 
        
        $('#itemSearchInput').val(''); // 카테고리 이동 시 검색창 깔끔하게 비우기
        applyCombinedFilters(); 
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

    // 페이지 처음 로딩 시 '모두보기' 상태로 세팅
    applyCombinedFilters();

    // =========================================================================
    // 3. 아이템 설명 마우스 툴팁 
    // =========================================================================
    const $tooltip = $('#item-tooltip');

    $('.item-table-container').on('mouseenter', '.item-row', function(e) {
        let itemInfo = $(this).data('info');
        if(itemInfo && itemInfo.trim() !== '') {
            $tooltip.html(itemInfo).show();
        }
    }).on('mousemove', '.item-row', function(e) {
        $tooltip.css({
            'left': (e.pageX + 15) + 'px',
            'top': (e.pageY + 15) + 'px'
        });
    }).on('mouseleave', '.item-row', function() {
        $tooltip.hide().html('');
    });

    $('.item-row').css('cursor', 'pointer');
    
});

// =========================================================================
// 4. 배틀그라운드 맵 및 마커 기능 (기존 코드 그대로 유지)
// =========================================================================
$(document).ready(function () {
    const mapAssets = {
        "에란겔 (Erangel)": "https://raw.githubusercontent.com/pubg/api-assets/master/Assets/Maps/Erangel_Main_Low_Res.png",
        "미라마 (Miramar)": "https://raw.githubusercontent.com/pubg/api-assets/master/Assets/Maps/Miramar_Main_Low_Res.png",
        "사녹 (Sanhok)": "https://raw.githubusercontent.com/pubg/api-assets/master/Assets/Maps/Sanhok_Main_Low_Res.png",
        "비켄디 (Vikendi)": "https://raw.githubusercontent.com/pubg/api-assets/master/Assets/Maps/Vikendi_Main_Low_Res.png",
        "테이고 (Taego)": "https://raw.githubusercontent.com/pubg/api-assets/master/Assets/Maps/Tiger_Main_Low_Res.png",
        "론도 (Rondo)": "https://raw.githubusercontent.com/pubg/api-assets/master/Assets/Maps/Neon_Main_Low_Res.png"
    };

    const markerData = {
        "기본 지도": [{ t: '30%', l: '45%', c: '#3b82f6' }, { t: '25%', l: '55%', c: '#3b82f6' }],
        "차량 스폰": [{ t: '40%', l: '50%', c: '#fbbf24' }, { t: '60%', l: '30%', c: '#fbbf24' }],
        "차고 위치": [{ t: '85%', l: '52%', c: '#06b6d4' }],
        "선박 위치": [{ t: '15%', l: '20%', c: '#a855f7' }],
        "비밀 방": [{ t: '12%', l: '75%', c: '#10b981' }]
    };

    const $mapImg = $('#mapImg');
    const $canvas = $('#canvas');

    function updateMarkers(type) {
        $canvas.find('.marker').remove();

        if (markerData[type]) {
            $.each(markerData[type], function (i, d) {
                const $marker = $('<div class="marker"></div>').css({
                    top: d.t,
                    left: d.l,
                    backgroundColor: d.c
                });
                $canvas.append($marker);
            });
        }
    }

    $('.map-btn').on('click', function () {
        const $btn = $(this);
        const mapName = $btn.text().trim();

        $btn.addClass('active').siblings('.map-btn').removeClass('active');
        $mapImg.attr('src', mapAssets[mapName]);
        updateMarkers("기본 지도");

        $('.filter-item').removeClass('active').first().addClass('active');
    });

    $('.filter-item').on('click', function () {
        const $item = $(this);
        const filterType = $item.text().trim();

        $item.addClass('active').siblings('.filter-item').removeClass('active');
        updateMarkers(filterType);
    });

    $mapImg.attr('src', mapAssets["에란겔 (Erangel)"]);
    updateMarkers("기본 지도");
});