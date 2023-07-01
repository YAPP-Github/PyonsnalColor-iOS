//
//  UIImageView+.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/06.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(_ kind: ImageAssetKind) {
        self.image = kind.image
    }
    
    func setImage(_ kind: ImageAssetKind.StoreTag) {
        self.image = kind.image
    }

    func setImage(_ kind: ImageAssetKind.Icon) {
        self.image = kind.image
    }
    
    func setImage(with url: URL) {
        self.kf.setImage(with: url)
    }
}
