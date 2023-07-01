//
//  ImageAssetKind.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/06.
//

import UIKit

enum ImageAssetKind: String {
    case loginApple = "login_apple"
    case loginKakao = "login_kakao"
    
    case logo = "logo"
    
    // MARK: - StoreTag
    case sevenEleven = "7-eleven"
    case cu = "cu"
    case gs25 = "gs25"
    case emart24 = "emart24"
    case pyonsnalColor = "pyonsnalColor"
    case tagNew = "tag_new"
    case bellSimple = "bellSimple"
    
    case event = "event"
    case eventSelected = "event.selected"
}

extension ImageAssetKind {
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
