//
//  FilterCellItem.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/25.
//

import Foundation

struct FilterCellItem: Hashable {
    var filterUseType: FilterUseType = .category
    var filter: FilterEntity?

    static func == (lhs: FilterCellItem, rhs: FilterCellItem) -> Bool {
        return lhs.filter?.defaultText == rhs.filter?.defaultText && lhs.filter?.filterType == rhs.filter?.filterType
    }

    enum FilterUseType {
        case refresh
        case category
    }
}
