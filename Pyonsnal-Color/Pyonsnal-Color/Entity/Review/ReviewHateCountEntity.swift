//
//  ReviewHateCountEntity.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/10/25.
//

struct ReviewHateCountEntity {
    let writerIds: [Int]
    let hateCount: Int
}

extension ReviewHateCountEntity: Hashable {}
extension ReviewHateCountEntity: Codable {}
