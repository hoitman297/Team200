package com.semi.spring.battleground.model.vo;


import lombok.Data;

@Data
public class BagItemInfoVO {
    private int itemNo;         // ITEM_NO (아이템 번호)
    private int categoryNo;     // CATEGORY_NO (1:무기, 2:부착물, 3:탄약, 4:방어구, 5:소모품)
    private String itemName;    // ITEM_NAME (아이템 이름)
    private String itemInfo;    // ITEM_INFO (아이템 설명)
    private String itemImg;     // ITEM_IMG (아이템 이미지 경로/URL)
    private String itemType;    // ITEM_TYPE (아이템 종류)
}