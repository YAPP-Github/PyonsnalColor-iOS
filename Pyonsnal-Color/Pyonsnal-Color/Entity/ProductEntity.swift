//
//  ProductEntity.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/24.
//

import Foundation

struct ProductEntity {
    let imageURL: URL
    let updated: String
    let name: String
    let price: String
    let description: String
    let giftItem: GiftItemEntity?
}
