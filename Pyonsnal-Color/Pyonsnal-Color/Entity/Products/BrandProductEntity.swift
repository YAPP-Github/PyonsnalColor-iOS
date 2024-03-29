//
//  BrandProductEntity.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/08.
//

import Foundation

struct BrandProductEntity: Decodable, ProductConvertable, Hashable {
    let productId: String
    let imageURL: URL
    let storeType: ConvenienceStore
    let updatedTime: String
    let name: String
    let price: String
    let description: String?
    let eventType: EventTag?
    let productType: ProductType
    let isFavorite: Bool?
    let isNew: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case productId = "id"
        case imageURL = "image"
        case storeType
        case updatedTime
        case name
        case price
        case description
        case eventType
        case productType
        case isFavorite
        case isNew
    }
}
