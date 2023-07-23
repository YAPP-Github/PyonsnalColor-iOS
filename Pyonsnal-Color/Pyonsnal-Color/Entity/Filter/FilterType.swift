//
//  Filter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/22.
//

import UIKit

enum BottomSheetType {
    case radio
    case check
    case checkWithImage
}

struct FilterItem {
    var title: String?
    var icon: UIImage?
    var iconDirection: IconDirection
    
    enum IconDirection {
        case left, right
    }
}


enum FilterType {
    case sort(item: FilterItem)
    case recommend(item: FilterItem)
    case category(item: FilterItem)
    case event(item: FilterItem)
    
    var bottomSheetType: BottomSheetType {
        switch self {
        case .sort:
            return .check
        case .recommend:
            return .radio
        case .category:
            return .checkWithImage
        case .event:
            return .checkWithImage
        }
    }
}
