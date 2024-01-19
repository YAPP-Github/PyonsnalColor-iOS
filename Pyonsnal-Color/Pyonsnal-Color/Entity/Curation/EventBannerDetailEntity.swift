//
//  EventBannerDetailEntity.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 1/19/24.
//

import Foundation

struct EventBannerDetailEntity: Decodable, Hashable {
    let thumbnailImage: String
    let detailImage: String
    let links: [String]
    
    enum CodingKeys: CodingKey {
        case thumbnailImage
        case detailImage
        case links
    }
}
