//
//  ImageAssetKind+TabBar.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/27.
//

import UIKit

extension ImageAssetKind {
    enum TabBar: String {
        case homeSelected = "icon_tab_home_selected"
        case homeUnselected = "icon_tab_home_unselected"
        case mySelected = "icon_tab_my_selected"
        case myUnselected = "icon_tab_my_unselected"
        case eventSelected = "icon_tab_sale_selected"
        case eventUnselected = "icon_tab_sale_unselected"
        
        var image: UIImage? {
            return .init(named: self.rawValue)
        }
    }
}
