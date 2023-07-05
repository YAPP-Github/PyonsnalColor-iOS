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
    case productTag = "product_tag"
    case eventTag = "event_tag"
    case keywordTag = "keyword_tag"
    
    case tagNew = "tag_new"
    case bellSimple = "bellSimple"
    case defaultPyonsnalColor = "default_PyonsnalColor"
    
    case event = "event"
    case eventSelected = "event.selected"
    
    /// TermsOfUse
    case iconClose = "icon_close"
    case check = "check"
    case checkSelected = "check.selected"
    case iconArrow = "icon_arrow"
}

extension ImageAssetKind {
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
