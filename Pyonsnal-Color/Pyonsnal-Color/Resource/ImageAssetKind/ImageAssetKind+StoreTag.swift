//
//  ImageAssetKind+StoreTag.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/03.
//

import UIKit

extension ImageAssetKind {
    enum StoreTag: String {
        case storeTagSevenEleven = "tag_store_7eleven"
        case storeTagCU = "tag_store_CU"
        case storeTagGS25 = "tag_store_GS"
        case storeTagEmart24 = "tag_store_emart24"
        
        var image: UIImage? {
            return .init(named: self.rawValue)
        }
    }
}
