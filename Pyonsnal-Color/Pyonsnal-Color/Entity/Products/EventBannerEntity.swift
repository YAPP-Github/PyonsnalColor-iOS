//
//  EventBannerEntity.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/09.
//

import Foundation

struct EventBannerEntity: Decodable, Hashable {
    let identifier: String
    let storeType: ConvenienceStore
    let thumbnailImageURL: String
    let imageURL: String?
    let title: String?
    let updatedTime: String
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case storeType
        case thumbnailImageURL = "thumbnailImage"
        case imageURL = "image"
        case title
        case updatedTime
    }
}
