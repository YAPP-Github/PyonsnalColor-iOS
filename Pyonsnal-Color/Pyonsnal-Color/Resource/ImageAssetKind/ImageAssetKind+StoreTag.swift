//
//  ImageAssetKind+StoreTag.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/03.
//

import UIKit

extension ImageAssetKind {
    enum StoreTag: String {
        case storeTagSevenEleven = "storeTag_7Eleven"
        case storeTagCU = "storeTag_CU"
        case storeTagGS25 = "storeTag_GS25"
        case storeTagEmart24 = "storeTag_Emart24"
        
        var image: UIImage? {
            return .init(named: self.rawValue)
        }
    }
}
