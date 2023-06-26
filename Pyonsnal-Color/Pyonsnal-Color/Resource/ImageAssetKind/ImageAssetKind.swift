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
    
    case tag_new = "tag_new"
    case bellSimple = "bellSimple"
    
    case event = "event"
    case event_selected = "event.selected"
}

extension ImageAssetKind {
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
