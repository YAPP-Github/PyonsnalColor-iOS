//
//  ReviewLikeCountEntity.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/10/25.
//

struct ReviewLikeCountEntity {
    let writerIds: [Int]
    let likeCount: Int
}

extension ReviewLikeCountEntity: Hashable {}
extension ReviewLikeCountEntity: Codable {}
