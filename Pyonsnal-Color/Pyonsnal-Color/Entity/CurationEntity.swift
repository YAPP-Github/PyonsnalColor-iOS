//
//  CurationEntity.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/24.
//

import Foundation

struct CurationEntity: Decodable, Hashable {
    let title: String
    let description: String
    // TODO: 상수프로퍼티로 변경
    var products: [BrandProductEntity]
}
