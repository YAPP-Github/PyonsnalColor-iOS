//
//  CurationEntity.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/24.
//

import Foundation

struct CurationProductsEntity: Decodable {
    let curationProducts: [CurationEntity]
}

struct CurationEntity: Decodable, Hashable {
    let title: String
    let subTitle: String
    let products: [ProductDetailEntity]
}
