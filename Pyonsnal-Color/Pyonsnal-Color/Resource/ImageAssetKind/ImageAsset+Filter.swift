//
//  ImageAsset+Filter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/22.
//

import UIKit

extension ImageAssetKind {
    enum Filter: String {
        case sortFilter = "icon_filter_view"
        case categoryFilter = "icon_filter"
        
        var image: UIImage? {
            return .init(named: self.rawValue)
        }
    }
}
