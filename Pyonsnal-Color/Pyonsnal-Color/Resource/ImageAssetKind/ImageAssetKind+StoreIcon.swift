//
//  ImageAssetKind+StoreIcon.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/02.
//

import UIKit

extension ImageAssetKind {
    enum StoreIcon: String {
        case icon7Eleven = "store_logo_7-eleven"
        case iconCU = "store_logo_CU"
        case iconEmart24 = "store_logo_emart24"
        case iconGS = "store_logo_GS"
        
        var image: UIImage? {
            return .init(named: self.rawValue)
        }
    }
}
