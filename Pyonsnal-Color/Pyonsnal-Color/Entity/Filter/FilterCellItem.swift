//
//  FilterCellItem.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/25.
//

import Foundation

struct FilterCellItem: Hashable {
    var filterUseType: FilterUseType = .category
    var defaultText: String?
    var isSelected: Bool = false
    
    enum FilterUseType {
        case refresh
        case category
    }
}
