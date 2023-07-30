//
//  ImageAssetKind+StoreIcon.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/02.
//

import UIKit

extension ImageAssetKind {
    enum StoreIcon: String {
        case sevenEleven = "store_logo_7-eleven"
        case cu = "store_logo_CU"
        case emart24 = "store_logo_emart24"
        case gs25 = "store_logo_GS"
        
        var image: UIImage? {
            return .init(named: self.rawValue)
        }
    }
}
