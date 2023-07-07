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
    }
}

extension ImageAssetKind.Icon {
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
