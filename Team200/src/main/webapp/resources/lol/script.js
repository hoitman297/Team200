$(document).ready(function() {

    // =========================================================================
    // 1. 카테고리 필터링 기능 (클래스 토글 방식)
    // =========================================================================
    let activeCategory = ""; 

    $('.category-btn').on('click', function() {
        const $this = $(this);
        const categoryName = $this.find('span').text().trim();
        
        // 모든 버튼에서 active 클래스 제거 및 흐리게 처리
        $('.category-btn').removeClass('active').css('opacity', '0.4');

        // 이미 선택된 버튼을 다시 누른 경우 (해제)
        if (activeCategory === categoryName) {
            activeCategory = ""; 
            $('.category-btn').css('opacity', '1'); // 다시 모든 버튼 선명하게
            $('.item-row').show(); 
            return; 
        }

        // 새로운 카테고리 선택
        activeCategory = categoryName; 
        $this.addClass('active').css('opacity', '1'); // 클릭한 버튼만 활성화

        // 카테고리별 태그 매핑
        let searchTags = [];
        switch(categoryName) {
            case "전사": searchTags = ["Damage", "Health"]; break;
            case "원거리 딜러": searchTags = ["AttackSpeed", "CriticalStrike"]; break;
            case "암살자": searchTags = ["ArmorPenetration", "Damage"]; break;
            case "마법사": searchTags = ["SpellDamage"]; break;
            case "탱커": searchTags = ["Armor", "SpellBlock", "Health"]; break;
            case "서포터": searchTags = ["ManaRegen", "Vision", "Active"]; break;
        }

        // 아이템 필터링
        $('.item-row').each(function() {
            let itemTags = $(this).data('tags') || ""; 
            let isMatch = searchTags.some(tag => itemTags.includes(tag));

            if (isMatch) $(this).show();
            else $(this).hide();
        });
    });


$(document).ready(function() {
    const $tooltip = $('#item-tooltip');

    // 아이템 행에 마우스 올렸을 때 툴팁만 띄워줌
    $('.item-row').on({
        'mouseenter': function(e) {
            let itemInfo = $(this).data('info');
            if(itemInfo) {
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
});
    // =========================================================================
    // 2. 아이템 설명 마우스 툴팁 (기존과 동일)
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
});