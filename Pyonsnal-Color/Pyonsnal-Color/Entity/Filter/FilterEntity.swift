//
//  FilterEntity.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/22.
//

import UIKit

struct FilterDataEntity: Decodable {
    let data: [FilterEntity]
}

class FilterEntity: Decodable {
    let filterType: FilterType
    var defaultText: String? // 카테고리에 보여질 이름
    var isSelected: Bool = false
    let filterItem: [FilterItemEntity]
    
    init(filterType: FilterType, defaultText: String?, filterItem: [FilterItemEntity]) {
        self.filterType = filterType
        self.defaultText = defaultText
        self.filterItem = filterItem
    }
}

struct FilterItemEntity: Decodable {
    let name: String
    let code: Int
    var isSelected = false
}

struct FilterDummy {
    static var data: FilterDataEntity = FilterDataEntity(
        data: [
            FilterEntity(
                filterType: .sort,
                defaultText: "최신순",
                filterItem: [
                    FilterItemEntity(name: "최신순", code: 1, isSelected: true),
                    FilterItemEntity(name: "낮은 가격순", code: 2),
                    FilterItemEntity(name: "높은 가격순", code: 3)
            ]),
            FilterEntity(
                filterType: .event,
                defaultText: "행사",
                filterItem: [
                    FilterItemEntity(name: "1+1", code: 4),
                    FilterItemEntity(name: "2+1", code: 5),
                    FilterItemEntity(name: "할인", code: 6),
                    FilterItemEntity(name: "증정", code: 7)
                ]),
            FilterEntity(
                filterType: .event,
                defaultText: "카테고리",
                filterItem: [
                    FilterItemEntity(name: "음료", code: 4),
                    FilterItemEntity(name: "아이스크림", code: 5),
                    FilterItemEntity(name: "생활용품", code: 6),
                    FilterItemEntity(name: "식품", code: 7),
                    FilterItemEntity(name: "과자", code: 6),
                    FilterItemEntity(name: "베이커리", code: 7)
                ]),
            FilterEntity(
                filterType: .event,
                defaultText: "상품 추천",
                filterItem: [
                    FilterItemEntity(name: "다이어트", code: 8),
                    FilterItemEntity(name: "인기있는", code: 9),
                    FilterItemEntity(name: "매운", code: 10),
                    FilterItemEntity(name: "혼밥", code: 11),
                    FilterItemEntity(name: "간식", code: 12),
                    FilterItemEntity(name: "밤샘", code: 13),
                    FilterItemEntity(name: "달달", code: 14),
                    FilterItemEntity(name: "캐릭터", code: 15)
                ])
        ])
}
