//
//  BrandProductEntity.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/08.
//

import Foundation

struct BrandProductEntity: Decodable, ProductConvertable, Hashable {
    let identifier: String
    let imageURL: URL
    let storeType: ConvenienceStore
    let updatedTime: String
    let name: String
    let price: String
    let description: String?
    let eventType: EventTag?
    let productType: ProductType
    let isNew: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case imageURL = "image"
        case storeType
        case updatedTime
        case name
        case price
        case description
        case eventType
        case productType
        case isNew
    }
}
