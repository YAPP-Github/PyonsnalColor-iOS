//
//  BrandProductEntity.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/08.
//

struct BrandProductEntity: Decodable {
    let imageURL: String
    let storeType: ConvenienceStore
    let updatedTime: String
    let name: String
    let price: String
    let description: String
    
    private enum CodingKeys: String, CodingKey {
        case imageURL = "image"
        case storeType
        case updatedTime
        case name
        case price
        case description
    }
}
