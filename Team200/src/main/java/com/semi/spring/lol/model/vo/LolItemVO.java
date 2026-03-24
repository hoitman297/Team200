package com.semi.spring.lol.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LolItemVO {
    private int itemNo;         // ITEM_NO (라이엇 아이템 고유 번호)
    private String itemName;    // ITEM_NAME
    private int itemPrice;      // ITEM_PRICE
    private String itemInfo;    // ITEM_INFO
    private String itemImg;     // ITEM_IMG
    private String itemTag;		// ITEM_TAG
    
}