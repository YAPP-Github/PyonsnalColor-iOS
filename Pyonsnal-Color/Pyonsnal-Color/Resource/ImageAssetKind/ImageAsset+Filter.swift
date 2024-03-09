//
//  ImageAsset+Filter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/22.
//

import UIKit

extension ImageAssetKind {
    enum Filter: String {
        case refreshFilter = "icon_filter_refresh"
        case sortFilter = "icon_filter_view"
        case filter = "icon_filter"
        
        var image: UIImage? {
            return .init(named: self.rawValue)
        }
    }
}
