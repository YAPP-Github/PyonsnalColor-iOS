//
//  ImageAssetKind+HeaderView.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/02.
//

import UIKit

extension ImageAssetKind {
    enum HeaderView: String {
        case iconBack = "icon_back"
        
        var image: UIImage? {
            return .init(named: self.rawValue)
        }
    }
}
