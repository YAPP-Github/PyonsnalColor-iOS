//
//  ImageAssetKind+Splash.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/08.
//

import UIKit

extension ImageAssetKind {
    enum Splash: String {
        case imageSplash = "image_splash"
        
        var image: UIImage? {
            return .init(named: self.rawValue)
        }
    }
}
