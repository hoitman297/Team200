$(document).ready(function() {

    // =========================================================================
    // 1. 카테고리 필터링 기능 (클래스 토글 방식)
    // =========================================================================
    let activeCategory = ""; 

    $('.category-btn').on('click', function() {
        const $this = $(this);
        const categoryName = $this.find('span').text().trim();
        
        $('.category-btn').removeClass('active').css('opacity', '0.4');

        if (activeCategory === categoryName) {
            activeCategory = ""; 
            $('.category-btn').css('opacity', '1'); 
            $('.item-row').show(); 
            return; 
        }

        activeCategory = categoryName; 
        $this.addClass('active').css('opacity', '1'); 

        let searchTags = [];
        switch(categoryName) {
            case "전사": searchTags = ["Damage", "Health"]; break;
            case "원거리 딜러": searchTags = ["AttackSpeed", "CriticalStrike"]; break;
            case "암살자": searchTags = ["ArmorPenetration", "Damage"]; break;
            case "마법사": searchTags = ["SpellDamage"]; break;
            case "탱커": searchTags = ["Armor", "SpellBlock", "Health"]; break;
            case "서포터": searchTags = ["ManaRegen", "Vision", "Active"]; break;
        }

        $('.item-row').each(function() {
            let itemTags = $(this).data('tags') || ""; 
            let isMatch = searchTags.some(tag => itemTags.includes(tag));

            if (isMatch) $(this).show();
            else $(this).hide();
        });
    });

    // =========================================================================
    // 2. 아이템 설명 마우스 툴팁 
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
    // 3. 룬 (특성) 로딩 기능
    // =========================================================================
    // 페이지 로드 시 첫 번째 룬(정밀)을 자동으로 클릭하여 세팅합니다.
    if ($(".path-icon").length > 0) {
        $(".path-icon").first().click();
    }
});

// 핵심 룬 클릭 시 특성 목록 가져오기 (전역 함수)
// 핵심 룬 클릭 시 특성 목록 가져오기
// 핵심 룬 클릭 시 특성 목록 가져오기
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
                
                // [핵심 로직 추가] 클릭한 룬의 이름이 '정밀'이면 4개, 아니면 3개를 보여줍니다.
                // (만약 DB에 저장된 이름이 '정밀 ' 처럼 공백이 있다면 trim()을 사용하거나 DB값을 맞춰주세요)
                let mainRuneCount = (runeName === '정밀') ? 4 : 3;
                
                data.forEach((t, index) => {
                    // 계산된 mainRuneCount 갯수만큼 큰 메인 룬으로 처리
                    let isMainRune = (index < mainRuneCount); 
                    
                    let slotClass = isMainRune ? "main-rune" : "sub-rune";
                    
                    let slotHtml = `<div class="talent-slot ${slotClass}" onclick="showDetail(this, '${t.talentName}', '${t.talentImg}', '${t.talentInfo}')">
                                        <img src="${t.talentImg}" alt="${t.talentName}">
                                    </div>`;
                                    
                    if (isMainRune) {
                        mainRunesHtml += slotHtml;
                    } else {
                        subRunesHtml += slotHtml;
                    }
                });
                
                mainRunesHtml += `</div>`;
                subRunesHtml += `</div>`;
                
                // 두 컨테이너를 합쳐서 화면에 출력
                $("#primary-slots-container").html(mainRunesHtml + subRunesHtml);
                
                // 첫 번째 특성을 자동 클릭하여 우측에 설명 띄우기
                setTimeout(() => {
                    $(".talent-slot").first().click();
                }, 100);
                
            } else {
                $("#primary-slots-container").html("<p style='color:white;'>데이터가 없습니다.</p>");
            }
        },
        error: function(xhr, status, error) {
            console.error("에러 발생: ", error);
            alert("특성 정보를 불러오는데 실패했습니다.");
        }
    });
}

// 개별 특성 클릭 시 우측 영역에 상세 정보 표시 (역슬래시 제거 유지)
function showDetail(element, name, imgUrl, info) {
    $(".talent-slot").removeClass("active");
    $(element).addClass("active");

    $("#desc-name").html(`<img src="${imgUrl}"> ${name}`);
    $("#desc-text").html(info);
}