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

struct FilterEntity: Decodable {
    /// 정렬
    var sortedMeta: [FilterItemEntity]
    /// 행사
    var tagMetaData: [FilterItemEntity]
    /// 카테고리
    var categoryMetaData: [FilterItemEntity]
    /// 상품 추천
    var eventMetaData: [FilterItemEntity]
    
    struct FilterItemEntity: Decodable {
        var defaultText: String?
        var name: String?
        var code: Int?
        var isSelected = false
    }
}

struct FilterDataEntity: Decodable {
    var data: [FilterEntity]
    
    struct FilterEntity: Decodable {
        var filterType: FilterType
        var defaultText: String?
        var isSelected: Bool
        var filterItem: [FilterItemEntity]
        
        enum FilterType: Decodable {
            case sort // 정렬
            case recommend // 상품 추천
            case category // 카테고리
            case event // 행사
        }
        
        struct FilterItemEntity: Decodable {
            var defaultText: String?
            var name: String?
            var code: Int?
            var isSelected = false
        }
    }
}

struct FilterDummy {
    static var data: FilterEntity = FilterEntity(
        sortedMeta: [ // 최신순
            FilterEntity.FilterItemEntity(name: "최신순", code: 1, isSelected: true),
            FilterEntity.FilterItemEntity(name: "낮은 가격순", code: 2),
            FilterEntity.FilterItemEntity(name: "높은 가격순", code: 3)
        ],
        tagMetaData: [ // 상품 추천
            FilterEntity.FilterItemEntity(name: "1+1", code: 4),
            FilterEntity.FilterItemEntity(name: "2+1", code: 5),
            FilterEntity.FilterItemEntity(name: "할인", code: 6),
            FilterEntity.FilterItemEntity(name: "증정", code: 7)
        ],
        categoryMetaData: [ // 카테고리
            FilterEntity.FilterItemEntity(name: "음료", code: 4),
            FilterEntity.FilterItemEntity(name: "아이스크림", code: 5),
            FilterEntity.FilterItemEntity(name: "생활용품", code: 6),
            FilterEntity.FilterItemEntity(name: "식품", code: 7),
            FilterEntity.FilterItemEntity(name: "과자", code: 6),
            FilterEntity.FilterItemEntity(name: "베이커리", code: 7)
        ],
        eventMetaData: [ // 행사
            FilterEntity.FilterItemEntity(name: "다이어트", code: 8),
            FilterEntity.FilterItemEntity(name: "인기있는", code: 9),
            FilterEntity.FilterItemEntity(name: "매운", code: 10),
            FilterEntity.FilterItemEntity(name: "혼밥", code: 11),
            FilterEntity.FilterItemEntity(name: "간식", code: 12),
            FilterEntity.FilterItemEntity(name: "밤샘", code: 13),
            FilterEntity.FilterItemEntity(name: "달달", code: 14),
            FilterEntity.FilterItemEntity(name: "캐릭터", code: 15)
        ])
}
