//
//  ImageAssetKind+Icon.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/01.
//

import UIKit

extension ImageAssetKind {
    enum Icon: String {
        case icon7Eleven = "icon_7Eleven"
        case iconCU = "icon_CU"
        case iconEmart24 = "icon_Emart24"
        case iconGS = "icon_GS"
        
        var image: UIImage? {
            return .init(named: self.rawValue)
        }
    }
}
