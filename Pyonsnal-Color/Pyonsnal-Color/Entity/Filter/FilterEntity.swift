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

struct FilterEntity: Decodable {
    let filterType: FilterType
    var defaultText: String? // 카테고리에 보여질 이름
    var isSelected: Bool = false
    var filterItem: [FilterItemEntity]

    enum CodingKeys: String, CodingKey {
        case filterType, filterItem
    }
    
    init(filterType: FilterType, defaultText: String?, filterItem: [FilterItemEntity]) {
        self.filterType = filterType
        self.defaultText = defaultText
        self.filterItem = filterItem
    }
}

extension FilterEntity: Hashable {
    static func == (lhs: FilterEntity, rhs: FilterEntity) -> Bool {
        return lhs.filterItem == rhs.filterItem
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(filterItem)
    }
}

struct FilterItemEntity: Decodable, Hashable {
    let name: String
    let code: Int
    var isSelected = false
    
    enum CodingKeys: String, CodingKey {
        case name, code
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(code)
    }
}
