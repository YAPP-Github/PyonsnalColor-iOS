//
//  EventProductEntity.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/24.
//

import Foundation

struct EventProductEntity: Decodable, ProductConvertable, Hashable {
    let productId: String
    let imageURL: URL
    let storeType: ConvenienceStore
    let updatedTime: String
    let name: String
    let price: String
    let originalPrice: String?
    let eventType: EventTag?
    let productType: ProductType
    let description: String?
    let isEventExpired: Bool?
    let giftItem: String?
    let isFavorite: Bool?
    let isNew: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case productId = "id"
        case imageURL = "image"
        case storeType
        case updatedTime
        case name
        case price
        case originalPrice = "originPrice"
        case eventType
        case productType
        case description
        case isEventExpired
        case giftItem = "giftImage"
        case isFavorite
        case isNew
    }
}
