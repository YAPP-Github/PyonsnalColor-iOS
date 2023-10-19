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
    
    case bellSimple = "bellSimple"
    case tagStore = "tag_store"
    
    case iconTitle = "icon_title"
    
    case event = "event"
    case eventSelected = "event.selected"
    
    case favorite = "icon_like_unselected"
    case favoriteSelected = "icon_like_selected"
    
    /// TermsOfUse
    case iconClose = "icon_close"
    case iconCloseSmall = "icon_close_small"
    case check = "check"
    case checkSelected = "check.selected"
    case checkSelectedRed = "check.selected.red"
    case iconArrow = "icon_arrow"
}

extension ImageAssetKind {
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
