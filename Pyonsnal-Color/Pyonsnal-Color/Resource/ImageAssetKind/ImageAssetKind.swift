//
//  ImageAssetKind.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/06.
//

import UIKit

enum ImageAssetKind: String {
    case sample = "sample_not_use"
}

extension ImageAssetKind {
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
