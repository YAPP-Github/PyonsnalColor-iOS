//
//  ImageAssetKind+Profile.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 11/16/23.
//

import UIKit

extension ImageAssetKind {
    enum Profile: String {
        case profileEdit = "profile_edit"
        case profilePlus = "profile_plus"
        
        var image: UIImage? {
            return .init(named: self.rawValue)
        }
    }
}
