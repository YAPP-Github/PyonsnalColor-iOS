//
//  ImageAssetKind+Icon.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/07.
//

import UIKit

extension ImageAssetKind {
    enum Icon: String {
        case iconPyonsnalColor = "icon_pyonsnalColor"
        case iconSearch = "icon_search"
        case iconDelete = "icon_delete"
    }
}

extension ImageAssetKind.Icon {
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
