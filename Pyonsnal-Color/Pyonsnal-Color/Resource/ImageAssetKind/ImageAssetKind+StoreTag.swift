//
//  ImageAssetKind+StoreTag.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/03.
//

import UIKit

extension ImageAssetKind {
    enum StoreTag: String {
        case sevenEleven = "tag_store_7eleven"
        case cu = "tag_store_CU"
        case gs25 = "tag_store_GS"
        case emart24 = "tag_store_emart24"
        
        var image: UIImage? {
            return .init(named: self.rawValue)
        }
    }
}
