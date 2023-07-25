//
//  FilterEntity.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/22.
//

import Foundation

struct CategoryFilter: Hashable {
    var categoryFilterType: CategoryFilterType = .category
    var defaultText: String?
    var isSelected: Bool = false
    
    enum CategoryFilterType {
        case refresh, category
    }
}

struct FilterDataEntity: Decodable {
    var data: [FilterEntity]
}

class FilterEntity: Decodable {
    var filterType: FilterType
    var defaultText: String? // 카테고리에 보여질 이름
    var isSelected: Bool = false
    var filterItem: [FilterItemEntity]
    
    init(
        filterType: FilterType,
        defaultText: String? = nil,
        filterItem: [FilterItemEntity]
    ) {
        self.filterType = filterType
        self.defaultText = defaultText
        self.filterItem = filterItem
    }
    
    enum FilterType: Decodable {
        case sort // 정렬
        case recommend // 상품 추천
        case category // 카테고리
        case event // 행사
        case unknown
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let type = try? container.decode(String.self)
            switch type {
            case "sort": self = .sort
            case "recommend": self = .recommend
            case "category": self = .category
            case "event": self = .event
            default: self = .unknown
            }
        }
    }
}

struct FilterItemEntity: Decodable {
    var name: String?
    var code: Int?
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
