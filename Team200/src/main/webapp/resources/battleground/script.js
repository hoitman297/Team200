$(document).ready(function() {
    // =========================================================================
    // 1. 테이블 페이징 및 필터링 관련 변수
    // =========================================================================
    let currentPage = 0;
    const rowsPerPage = 8; // 배그 아이템은 세로 높이가 약간 작아서 10개씩 보여주는 것이 좋습니다. 원하시면 6으로 변경하세요.
    let visibleRows = [];

    // 화면에 지정된 개수만큼 끊어서 보여주는 함수
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
        
        // 검색 결과가 아예 없을 경우 빈 화면 대신 안내 문구 표시 처리를 원한다면 이곳에 추가할 수 있습니다.
    }

    // ✨ 검색어 검사 필터 함수 ✨
    // (배그는 카테고리를 클릭하면 a 태그로 인해 페이지가 아예 이동해버리므로, 카테고리 필터는 JSP가 알아서 해줍니다.)
    function applySearchFilter() {
        // 현재 검색창에 적힌 글자 가져오기 (소문자로 변환하여 대소문자 무시)
        const searchTerm = $('#itemSearchInput').val().toLowerCase();
        visibleRows = []; // 보여줄 목록 초기화

        // 모든 아이템을 하나씩 검사
        $('.item-row').each(function() {
            const itemName = ($(this).data('name') || "").toLowerCase();

            // 검색어가 이름에 포함되어 있는가?
            let isSearchMatch = itemName.includes(searchTerm);

            // 조건을 만족하면 화면에 표시할 목록(visibleRows)에 추가
            if (isSearchMatch) {
                visibleRows.push(this);
            }
        });

        // 필터링이 끝났으니 무조건 1페이지(인덱스 0)로 돌려놓고 화면 갱신
        currentPage = 0;
        updateTablePaging();
    }

    // =========================================================================
    // 2. 이벤트 리스너 (검색창 입력, 이전/다음 버튼)
    // =========================================================================

    // 검색창 입력 이벤트 (글자를 칠 때마다 즉시 적용)
    $('#itemSearchInput').on('input', function() {
        applySearchFilter();
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

    // 페이지가 처음 로딩될 때 전체 목록(JSP가 렌더링한 해당 카테고리 전체)을 10개씩 잘라서 보여주기
    applySearchFilter();


    // =========================================================================
    // 3. 아이템 설명 마우스 툴팁 
    // =========================================================================
    const $tooltip = $('#item-tooltip');

    // 동적으로 생성/숨김 처리되는 요소들이므로 이벤트 위임을 사용하거나 필터링 전에 이벤트를 겁니다.
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



$(document).ready(function () {
    // 1. 자산 및 마커 데이터 (기존 유지)
// 1. 자산 데이터 (script.js와 이미지가 같은 폴더에 있을 때)
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

    // 2. 마커 업데이트 함수
    function updateMarkers(type) {
        // 기존 마커 싹 제거
        $canvas.find('.marker').remove();

        if (markerData[type]) {
            $.each(markerData[type], function (i, d) {
                // jQuery로 div 생성과 스타일 적용을 동시에
                const $marker = $('<div class="marker"></div>').css({
                    top: d.t,
                    left: d.l,
                    backgroundColor: d.c
                });
                $canvas.append($marker);
            });
        }
    }

    // 3. 지도 선택 버튼 클릭 이벤트
    $('.map-btn').on('click', function () {
        const $btn = $(this);
        const mapName = $btn.text().trim();

        // 버튼 활성화 처리
        $btn.addClass('active').siblings('.map-btn').removeClass('active');

        // 이미지 교체 및 초기화
        $mapImg.attr('src', mapAssets[mapName]);
        updateMarkers("기본 지도");

        // 필터 아이템 첫 번째꺼 활성화 (기본값)
        $('.filter-item').removeClass('active').first().addClass('active');
    });

    // 4. 필터 아이템 클릭 이벤트
    $('.filter-item').on('click', function () {
        const $item = $(this);
        const filterType = $item.text().trim();

        $item.addClass('active').siblings('.filter-item').removeClass('active');
        updateMarkers(filterType);
    });

    // 5. 초기 실행 (페이지 로드 시)
    $mapImg.attr('src', mapAssets["에란겔 (Erangel)"]);
    updateMarkers("기본 지도");
});