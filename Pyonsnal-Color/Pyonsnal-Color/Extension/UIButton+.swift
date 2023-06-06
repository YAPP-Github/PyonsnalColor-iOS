//
//  UIButton+.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/06.
//

import UIKit

extension UIButton {
    func setImage(_ kind: ImageAssetKind, for state: UIControl.State) {
        self.setImage(kind.image, for: state)
    }
}
