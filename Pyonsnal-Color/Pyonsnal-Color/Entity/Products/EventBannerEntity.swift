//
//  EventBannerEntity.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/09.
//

import Foundation

struct EventBannerEntity: Decodable, Hashable {
    let storeType: ConvenienceStore
    let thumbnailImageURL: URL
    let imageURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case storeType
        case thumbnailImageURL = "thumbnailImage"
        case imageURL = "image"
    }
}
