//
//  UIImageView+.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/06.
//

import UIKit

extension UIImageView {
    func setImage(_ kind: ImageAssetKind) {
        self.image = kind.image
    }
}
