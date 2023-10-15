//
//  ReviewEntity.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/18.
//

import Foundation

struct ReviewEntity {
    let taste: ReviewEvaluationState
    let quality: ReviewEvaluationState
    let valueForMoney: ReviewEvaluationState
    let score: Double
    let contents: String
    let image: URL?
    let writerId: Int?
    let writerName: String
    let createdTime: String
    let updatedTime: String
    let likeCount: Int
    let hateCount: Int
}

extension ReviewEntity: Hashable {}

extension ReviewEntity: Codable {
}
