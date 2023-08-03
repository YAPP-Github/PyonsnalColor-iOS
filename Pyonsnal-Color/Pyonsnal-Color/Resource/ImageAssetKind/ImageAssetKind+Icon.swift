//
//  ImageAssetKind+Icon.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/07.
//

import UIKit

extension ImageAssetKind {
    enum Icon: String {
        case iconHeader = "icon_header"
        case iconPyonsnalColor = "icon_pyonsnalColor"
        case iconSearch = "icon_search"
        case iconDelete = "icon_delete"
        case iconCheck = "icon_check"
    }
}

extension ImageAssetKind.Icon {
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
