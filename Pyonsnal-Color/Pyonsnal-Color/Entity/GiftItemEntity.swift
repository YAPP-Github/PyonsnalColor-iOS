//
//  GiftItemEntity.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/24.
//

import Foundation

struct GiftItemEntity: Decodable, Hashable {
    let name: String
    let price: String
    let imageURL: URL
}
