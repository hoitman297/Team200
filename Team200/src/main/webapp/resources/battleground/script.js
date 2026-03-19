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